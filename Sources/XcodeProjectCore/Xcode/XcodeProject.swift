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
    public init(
        xcodeprojectURL: URL,
        parser: ContextParser = PBXProjectContextParser(),
        fileWriter: Writer = FileWriter(),
        fileReferenceAppender: FileReferenceAppender = FileReferenceAppenderImpl(),
        groupAppender: GroupAppender = GroupAppenderImpl(),
        resourcesBuildPhaseAppender: BuildPhaseAppender = ResourceBuildPhaseAppenderImpl(),
        sourcesBuildPhaseAppender: BuildPhaseAppender = SourceBuildPhaseAppenderImpl(),
        bulidFileAppender: BuildFileAppenderImpl = BuildFileAppenderImpl(),
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator()
        ) throws {
        context = try parser.parse(xcodeprojectUrl: xcodeprojectURL)
        self.fileWriter = fileWriter
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
        var next = group.parentGroup
        var expectedFullPath = group.pathOrNameOrEmpty
        while let parentGroup = next {
            if mainGroup === parentGroup {
                break
            }
            expectedFullPath = parentGroup.pathOrNameOrEmpty + "/" + expectedFullPath
            next = next?.parentGroup
        }
        expectedFullPath = context.xcodeprojectDirectoryURL.path + "/" + expectedFullPath
        print("expectedDirectoryFullPath: \(expectedFullPath)")
        return expectedFullPath
    }
    func fileReferenceFullPath(_ fileRef: PBX.FileReference) -> String {
        return context.xcodeprojectDirectoryURL.path + "/" + fileRef.fullPath
    }
    func expectedFileReferenceFullPath(_ fileRef: PBX.FileReference) -> String {
        var next = fileRef.parentGroup
        var expectedFullPath = ""
        while let parentGroup = next {
            if mainGroup === parentGroup {
                break
            }
            switch expectedFullPath.isEmpty {
            case true:
                expectedFullPath = parentGroup.pathOrNameOrEmpty
            case false:
                expectedFullPath = parentGroup.pathOrNameOrEmpty + "/" + expectedFullPath
            }
            next = next?.parentGroup
        }
        expectedFullPath += "/" + fileRef.pathOrNameOrEmpty
        expectedFullPath = context.xcodeprojectDirectoryURL.path + "/" + expectedFullPath
        print("expectedFileReferenceFullPath: \(expectedFullPath)")
        return expectedFullPath
    }
    
    public func sync(from startDirectory: String? = nil) throws {
        let startDirectory = context.xcodeprojectDirectoryURL.path + "/" + (startDirectory ?? "") + "/"
        let list = groups.filter { $0.isa == .PBXGroup }
        try list.forEach { group in
            print("*************************************************")
            print("group.id: \(group.id)")
            let destinationDirectoryFullPath = expectedDirectoryFullPath(group)
            print("destinationDirectoryFullPath: \(destinationDirectoryFullPath)")
            if !destinationDirectoryFullPath.contains(startDirectory) {
                return
            }
            var isDirectory = ObjCBool(false)
            let isDestinationDirectoryPathExists = FileManager.default.fileExists(atPath: destinationDirectoryFullPath, isDirectory: &isDirectory)
            let shouldCreateDirectory = !isDestinationDirectoryPathExists || !isDirectory.boolValue
            if shouldCreateDirectory {
                print("mkdir -p \(destinationDirectoryFullPath)")
                do {
                    try FileManager.default.createDirectory(at: URL(fileURLWithPath: destinationDirectoryFullPath), withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                    exit(1)
                }
            }
        }
        
        try list.flatMap { $0.fileRefs }.forEach { fileRef in
            print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
            print("fileRef.id: \(fileRef.id)")
            let sourceFileReferenceFullPath = fileReferenceFullPath(fileRef)
            print("sourceFileReferenceFullPath: \(sourceFileReferenceFullPath)")
            if !sourceFileReferenceFullPath.contains(startDirectory) {
                return
            }
            let destinationFileReferenceFullPath = expectedFileReferenceFullPath(fileRef)
            print("destinationFileReferenceFullPath: \(destinationFileReferenceFullPath)")
            if !destinationFileReferenceFullPath.contains(startDirectory) {
                return
            }

            let isSamePath = sourceFileReferenceFullPath == destinationFileReferenceFullPath
            let shouldRemoveFile = !isSamePath && FileManager.default.fileExists(atPath: destinationFileReferenceFullPath)
            if shouldRemoveFile {
                print("\(destinationFileReferenceFullPath) is already exists. And will remove it.")
                print("rm -f \(destinationFileReferenceFullPath)")
                try FileManager.default.removeItem(atPath: destinationFileReferenceFullPath)
            }
            
            let shouldMoveFile = !isSamePath
            if shouldMoveFile {
                print("mv \(sourceFileReferenceFullPath) \(destinationFileReferenceFullPath)")
                do {
                    try FileManager.default.moveItem(atPath: sourceFileReferenceFullPath, toPath: destinationFileReferenceFullPath)
                } catch {
                    print(error.localizedDescription)
                    exit(1)
                }
            }
        }
        

        list.forEach { group in
            if let name = group.name {
                group.name = nil
                group.path = name
                context.resetGroupFullPaths()
            }
        }

        try write()
    }
}


// MARK: - Write
extension XcodeProject {
    public func write() throws {
       try fileWriter.write(xcodeProject: self)
    }
}
