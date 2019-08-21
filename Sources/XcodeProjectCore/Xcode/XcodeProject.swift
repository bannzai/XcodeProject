//
//
//  XcodeProject.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/20.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

public class XcodeProject {
    internal let context: Context
    private let fileReferenceAppender: FileReferenceAppender
    private let groupAppender: GroupAppender
    private let bulidFileAppender: BuildFileAppender
    private let resourcesBuildPhaseAppender: BuildPhaseAppender
    private let sourcesBuildPhaseAppender: BuildPhaseAppender
    private let fileWriter: Writer
    private let fileSystemWriter: FileSystemWriter
    public init(
        xcodeprojectURL: URL,
        parser: ContextParser = PBXProjectContextParser(),
        fileWriter: Writer = FileWriter(),
        fileSystemWriter: FileSystemWriter = FileSystemWriterImpl(),
        fileReferenceAppender: FileReferenceAppender = FileReferenceAppenderImpl(),
        groupAppender: GroupAppender = GroupAppenderImpl(),
        resourcesBuildPhaseAppender: BuildPhaseAppender = ResourceBuildPhaseAppenderImpl(),
        sourcesBuildPhaseAppender: BuildPhaseAppender = SourceBuildPhaseAppenderImpl(),
        bulidFileAppender: BuildFileAppenderImpl = BuildFileAppenderImpl(),
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator()
        ) throws {
        context = try parser.parse(xcodeprojectUrl: xcodeprojectURL)
        self.fileWriter = fileWriter
        self.fileSystemWriter = fileSystemWriter
        self.fileReferenceAppender = fileReferenceAppender
        self.groupAppender = groupAppender
        self.resourcesBuildPhaseAppender = resourcesBuildPhaseAppender
        self.sourcesBuildPhaseAppender = sourcesBuildPhaseAppender
        self.bulidFileAppender = bulidFileAppender
    }
}

// MARK: Convenience Accessors
extension XcodeProject {
    public var rootID: String {
        return context.rootID
    }
    public var objects: [String: PBX.Object] {
        return context.objects
    }
    public var mainGroup: PBX.Group {
        return context.mainGroup
    }
    public var fileRefs: [PBX.FileReference] {
        return context.fileRefs
    }
    public var groups: [PBX.Group] {
        return context.groups
    }
    public var buildFiles: [PBX.BuildFile] {
        return context.buildFiles
    }
    public var buildPhases: [PBX.BuildPhase] {
        return context.buildPhases
    }
    public var targets: [PBX.Target] {
        return context.targets
    }
}

// MARK: - Remove
extension XcodeProject {
    // TODO: Prepare Remover
    @discardableResult public func removeFile(path: PBXRawPathType, targetName: String) -> PBX.FileReference {
        guard let fileName = path.components(separatedBy: "/").last else {
            fatalError(assertionMessage(description: "Unexpected pattern for file path: \(path)"))
        }
        
        let lastKnownType = KnownFileExtension(fileName: fileName)
        switch lastKnownType.type {
        case .resourceFile:
            targets[name: targetName]?.removeToResourceBuildFile(fileName: fileName)
        case .sourceCode:
            targets[name: targetName]?.removeToSourceBuildFile(fileName: fileName)
        case _:
            break
        }
        
        let groupPathNames = Array(path
            .components(separatedBy: "/")
            .filter { !$0.isEmpty }
            .dropLast()
        )
        let groupPath = groupPathNames.joined(separator: "/")
        
        let targetGroup = GroupExtractorImpl().extract(context: context, path: groupPath) ?? context.mainGroup
        guard let removedFileRef = targetGroup.removeFile(fileName: fileName) else {
            fatalError("Could not find file reference for filename of \(fileName)")
        }

        return removedFileRef
    }
    
    @discardableResult public func removeGroup(path: PBXRawPathType) -> PBX.Group? {
        if path.isEmpty {
            return nil
        }
        
        let target = GroupExtractorImpl().extract(context: context, path: path)
        LOOP:
            for group in groups {
                let index = group.children.firstIndex { subGroup in subGroup === target }
                switch index {
                case .none:
                    continue
                case .some(let index):
                    group.children.remove(at: index)
                    break LOOP
                }
        }
        return target
    }
}

// MARK: - Append
extension XcodeProject {
    @discardableResult public func appendFile(path: PBXRawPathType, targetName: String) -> PBX.FileReference {
        let groupPathNames = Array(path
            .components(separatedBy: "/")
            .filter { !$0.isEmpty }
            .dropLast()
        )
        
        appendGroup(path: groupPathNames.joined(separator: "/"), targetName: targetName)
        
        let fileRef = fileReferenceAppender.append(context: context, filePath: path)
        
        guard let fileName = fileRef.path else {
            fatalError(assertionMessage(description: "Unexpected pattern for file path is nil after appended file reference: \(fileRef), filePath: \(path), targetName: \(targetName)"))
        }
        
        bulidFileAppender.append(context: context, fileRefID: fileRef.id, targetName: targetName, fileName: fileRef.path!)
        
        let lastKnownType = KnownFileExtension(fileName: fileName)
        switch lastKnownType.type {
        case .resourceFile:
            resourcesBuildPhaseAppender.append(context: context, targetName: targetName)
        case .sourceCode:
            sourcesBuildPhaseAppender.append(context: context, targetName: targetName)
        case _:
            break
        }
        
        return fileRef
    }
    
    @discardableResult public func appendGroup(path: PBXRawPathType, targetName: String) -> PBX.Group? {
        return path.isEmpty ? nil : groupAppender.append(context: context, childrenIDs: [], path: path)
    }
}

// MARK: - Lint
extension XcodeProject {
    func expectedDirectoryFullPath(_ group: PBX.Group) -> String {
        let path = group.expectedFileSystemAbsolutePath
        return path
    }
    func fileReferenceFullPath(_ fileRef: PBX.FileReference) -> String {
        return fileRef.fileSystemAbsolutePath
    }
    func expectedFileReferenceFullPath(_ fileRef: PBX.FileReference) -> String {
        let path = fileRef.expectedFileSystemAbsolutePath
        return path
    }
    
    func isNotImplementCase(_ sourceTreeType: SourceTreeType) -> Bool {
        switch sourceTreeType {
        case .environment(let env):
            switch env {
            case .BUILT_PRODUCTS_DIR, .SDKROOT:
                return false
            case _:
                return true
            }
        case _:
            return true
        }
    }
    
    func restructure(from startDirectory: String? = nil) {
        let startDirectory = context.xcodeprojectDirectoryURL.path + "/" + (startDirectory ?? "") + "/"
        groups.flatMap { $0.fileRefs }.filter { isNotImplementCase($0.sourceTree) }.forEach { fileRef in
            switch fileRef.sourceTree {
            case .group, .absolute:
                return
            case .environment(let env):
                switch env {
                case .SOURCE_ROOT:
                    if let filename = fileRef.path?.components(separatedBy: "/").last {
                        fileRef.sourceTree = .group
                        fileRef.path = filename
                    }
                case _:
                    return
                }
            }
        }
        
        groups.filter { $0.isa != .PBXVariantGroup }.forEach { group in
            let destinationDirectoryFullPath = expectedDirectoryFullPath(group)
            if !destinationDirectoryFullPath.contains(startDirectory) {
                return
            }
            if let name = group.name {
                group.name = nil
                group.path = name
                context.resetGroupFullPaths()
            }
        }

    }
    
    func syncFileSystem(from startDirectory: String? = nil) throws {
        let startDirectory = context.xcodeprojectDirectoryURL.path + "/" + (startDirectory ?? "") + "/"
        try groups.flatMap { $0.fileRefs }.filter { isNotImplementCase($0.sourceTree) }.forEach { fileRef in
            let sourceFileReferenceFullPath = fileReferenceFullPath(fileRef)
            let destinationFileReferenceFullPath = expectedFileReferenceFullPath(fileRef)
            if !sourceFileReferenceFullPath.contains(startDirectory) {
                return
            }
            if !destinationFileReferenceFullPath.contains(startDirectory) {
                return
            }
            let destinationDirectoryFullPath = destinationFileReferenceFullPath.components(separatedBy: "/").dropLast().joined(separator: "/")
            if !destinationDirectoryFullPath.contains(startDirectory) {
                return
            }
            
            let isDestinationDirectoryPathExists = fileSystemWriter.isExists(path: destinationDirectoryFullPath)
            let shouldCreateDirectory = !isDestinationDirectoryPathExists
            if shouldCreateDirectory {
                print("🛠 Make directory for \(destinationDirectoryFullPath)")
                try fileSystemWriter.createDirectory(path: destinationDirectoryFullPath)
            }
            
            
            let isSamePath = sourceFileReferenceFullPath == destinationFileReferenceFullPath
            let shouldRemoveFile = !isSamePath && fileSystemWriter.isExists(path: destinationFileReferenceFullPath)
            if shouldRemoveFile {
                print("🗑 \(destinationFileReferenceFullPath) is already exists. And will remove it.")
                try fileSystemWriter.remove(path: destinationFileReferenceFullPath)
            }
            
            let shouldMoveFile = !isSamePath
            if shouldMoveFile {
                print("♻️ Move directory from \(sourceFileReferenceFullPath) to \(destinationFileReferenceFullPath)")
                try fileSystemWriter.move(source: sourceFileReferenceFullPath, destination: destinationFileReferenceFullPath)
            }
        }
    }
    
    public func sync(from startDirectory: String? = nil) throws {
        try syncFileSystem()
        restructure()
        try write()
    }
}


// MARK: - Write
extension XcodeProject {
    public func write() throws {
       try fileWriter.write(xcodeProject: self)
    }
}
