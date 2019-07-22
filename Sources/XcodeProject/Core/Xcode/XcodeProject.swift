//
//
//  XcodeProject.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/20.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

open class XcodeProject {
    public private(set) lazy var projectName: String = parser.projectName()
    public private(set) lazy var pbxUrl: URL = parser.projectURL()
    public private(set) lazy var context: Context = parser.context()
    public private(set) lazy var project: PBX.Project = parser.rootObject(with: context)
    public private(set) lazy var fullPair: PBXRawMapType = parser.pair()
    
    private let parser: Parser
    private let hashIDGenerator: StringGenerator

    public init(
        parser: Parser,
        hashIDGenerator: StringGenerator
        ) {
        self.parser = parser
        self.hashIDGenerator = hashIDGenerator
        self.context.inject(contexualXcodeProject: self)
    }
}

// MARK: - Append
extension XcodeProject {
    fileprivate func appendFileRef(_ fileName: String, and fileRefId: String) {
        let fileRef: PBX.FileReference
        
        let isa = ObjectType.PBXFileReference.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "fileEncoding": 4,
            "lastKnownFileType": LastKnownFile(fileName: fileName).value,
            "path": fileName,
            "sourceTree": "<group>"
        ]
        
        fileRef = PBX.FileReference(
            id: fileRefId,
            dictionary: pair,
            isa: isa,
            context: context
        )
        
        context.dictionary[fileRefId] = fileRef
    }
    
    private func makeGroupEachPaths(for projectRootPath: String) -> [(PBX.Group, String)] {
        return context
            .dictionary
            .values
            .compactMap {
                $0 as? PBX.Group
            }
            .compactMap { group -> (PBX.Group, String) in
                let path = (projectRootPath + group.fullPath)
                    .components(separatedBy: "/")
                    .filter { !$0.isEmpty }
                    .joined(separator: "/")
                return (group, path)
        }
    }
    
    func appendGroupIfNeeded(with groupEachPaths: [(PBX.Group, String)], childId: String, groupPathNames: [String]) {
        if groupPathNames.isEmpty {
            return
        }
        
        let groupPath = groupPathNames.joined(separator: "/")
        let alreadyExistsGroup = groupEachPaths
            .filter { (group, path) -> Bool in
                return path == groupPath
            }
            .first
        
        if let group = alreadyExistsGroup?.0 {
            let reference: PBX.Reference = context.dictionary[childId] as! PBX.Reference
            group.children.append(reference)
            return
        } else {
            guard let pathName = groupPathNames.last else {
                fatalError("unexpected not exists last value")
            }
            
            let isa = ObjectType.PBXGroup.rawValue
            let pair: PBXRawMapType = [
                "isa": isa,
                "children": [
                    childId
                ],
                "path": pathName,
                "sourceTree": "<group>"
            ]
            
            let uuid = hashIDGenerator.generate()
            let group = PBX.Group(
                id: uuid,
                dictionary: pair,
                isa: isa,
                context: context
            )
            
            context.dictionary[uuid] = group
            appendGroupIfNeeded(with: groupEachPaths, childId: uuid, groupPathNames: Array(groupPathNames.dropLast()))
        }
    }
    
    private func makeBuildFile(for buildFileId: String, and fileRefId: String) -> PBX.BuildFile { // build file
        let isa = ObjectType.PBXBuildFile.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "fileRef": fileRefId,
            ]
        
        let buildFile = PBX.BuildFile(
            id: buildFileId,
            dictionary: pair,
            isa: isa,
            context: context
        )
        context.dictionary[buildFileId] = buildFile
        
        return buildFile
    }
    
    private func appendBuildPhase(with buildPhaseId: String, and buildFile: PBX.BuildFile, for targetName: String, fileName: String) {
        guard let target = context
            .dictionary
            .values
            .compactMap ({ $0 as? PBX.NativeTarget })
            .filter ({ $0.name == targetName })
            .first
            else {
                fatalError(assertionMessage(description: "Unexpected target name \(targetName)"))
        }
        
        let lastKnownType = LastKnownFile(fileName: fileName)
        switch lastKnownType.type {
        case .resourceFile, .markdown, .text:
            appendResourceBuildPhase(with: buildPhaseId, and: buildFile, target: target)
        case .sourceCode:
            appendSourceBuildPhase(with: buildPhaseId, and: buildFile, target: target)
        }
    }
    
    private func appendSourceBuildPhase(with buildPhaseId: String, and buildFile: PBX.BuildFile, target: PBX.NativeTarget) {
        let sourcesBuildPhase = target.buildPhases.compactMap { $0 as? PBX.SourcesBuildPhase }.first
        guard sourcesBuildPhase == nil else {
            // already exists
            sourcesBuildPhase?.files.append(buildFile)
            return
        }
        
        let isa = ObjectType.PBXSourcesBuildPhase.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "buildActionMask": Int32.max,
            "files": [
                buildFile.id
            ],
            "runOnlyForDeploymentPostprocessing": 0
        ]
        
        context.dictionary[buildPhaseId] = PBX.SourcesBuildPhase(
            id: buildPhaseId,
            dictionary: pair,
            isa: isa,
            context: context
        )
    }
    
    private func appendResourceBuildPhase(with buildPhaseId: String, and buildFile: PBX.BuildFile, target: PBX.NativeTarget) {
        let builPhase = target.buildPhases.compactMap { $0 as? PBX.ResourcesBuildPhase }.first
        guard builPhase == nil else {
            // already exists
            builPhase?.files.append(buildFile)
            return
        }
        
        let isa = ObjectType.PBXResourcesBuildPhase.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "buildActionMask": Int32.max,
            "files": [
                buildFile.id
            ],
            "runOnlyForDeploymentPostprocessing": 0
        ]
        
        context.dictionary[buildPhaseId] = PBX.ResourcesBuildPhase(
            id: buildPhaseId,
            dictionary: pair,
            isa: isa,
            context: context
        )
    }
    
    public func appendFilePath(
        with projectRootPath: String,
        filePath: String,
        targetName: String
        ) {
        let pathComponents = filePath.components(separatedBy: "/").filter { !$0.isEmpty }
        let groupPathNames = Array(pathComponents.dropLast())
        guard
            let fileName = pathComponents.last
            else {
                fatalError(assertionMessage(description: "unexpected get file name for append"))
        }
        
        let fileRefId = hashIDGenerator.generate()
        appendFileRef(fileName, and: fileRefId)
        
        context.resetFullFilePaths(with: project)
        
        let groupEachPaths = makeGroupEachPaths(for: projectRootPath)
        appendGroupIfNeeded(with: groupEachPaths, childId: fileRefId, groupPathNames: groupPathNames)
        
        let buildFileId = hashIDGenerator.generate()
        let buildFile = makeBuildFile(for: buildFileId, and: fileRefId)
        
        let buildPhaseId = hashIDGenerator.generate()
        appendBuildPhase(with: buildPhaseId, and: buildFile, for: targetName, fileName: fileName)
    }
}
