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
    public func sync() throws {
        try groups
            .filter { !$0.fullPath.isEmpty }
            .forEach { group in
                let path = context.xcodeprojectDirectoryURL.absoluteString + "/" + group.fullPath
                var isDirectory = ObjCBool(false)
                let isFileExists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
                let isNecessaryCreateDirectory = !isFileExists || !isDirectory.boolValue
                if !isNecessaryCreateDirectory {
                    return
                }
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
        }
    }
}


// MARK: - Write
extension XcodeProject {
    public func write() throws {
       try fileWriter.write(xcodeProject: self)
    }
}
