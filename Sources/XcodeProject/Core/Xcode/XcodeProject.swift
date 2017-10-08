//
//
//  XcodeProject.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/20.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

public typealias PBXPair = [String: Any]

open class XcodeProject {
    
    open let projectName: String
    open let allPBX: AllPBX
    open let project: PBX.Project
    open let pbxUrl: URL
    open let fullPair: PBXPair
    
    public init(repository: XcodeProjectRepository) {
        projectName = repository.fetchProjectName()
        allPBX = repository.fetchAllPBX()
        project = repository.fetchPBXProject()
        pbxUrl = repository.fetchXcodeProjectURL()
        fullPair = repository.fetchAllPair()
        
        allPBX.resetFullFilePaths(with: project)
    }
    
    public convenience init(for pbxUrl: URL) throws {
        let repository = try XcodeProjectRepositoryImpl(xcodeprojectUrl: pbxUrl)
        self.init(repository: repository)
    }
}

extension XcodeProject {
    private func generateHashId() -> String {
        let all = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters.map { String($0) }
        var result: String = ""
        for _ in 0..<24 {
            result += all[Int(arc4random_uniform(UInt32(all.count)))]
        }
        return result
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
        
        let fileRefId = generateHashId()
        let fileRef: PBX.FileReference
        do { // file ref
            let isa = ObjectType.PBXFileReference.rawValue
            let pair: PBXPair = [
                "isa": isa,
                "fileEncoding": 4,
                "lastKnownFileType": LastKnownFileType(fileName: fileName).value,
                "path": fileName,
                "sourceTree": "<group>"
            ]
            
            fileRef = PBX.FileReference(
                id: fileRefId,
                dictionary: pair,
                isa: isa,
                allPBX: allPBX
            )
            
            allPBX.dictionary[fileRefId] = fileRef
        }
        
        do { // groups
            allPBX.resetFullFilePaths(with: project)
            
            let groupEachPaths = allPBX
                .dictionary
                .values
                .flatMap {
                    $0 as? PBX.Group
                }
                .flatMap { group -> (PBX.Group, String) in
                    let path = (projectRootPath + group.fullPath)
                        .components(separatedBy: "/")
                        .filter { !$0.isEmpty }
                        .joined(separator: "/")
                    return (group, path)
            }
            
            func appendGroupIfNeeded(with childId: String, groupPathNames: [String]) {
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
                    let reference: PBX.Reference = allPBX.dictionary[childId] as! PBX.Reference
                    group.children.append(reference)
                    return
                } else {
                    guard let pathName = groupPathNames.last else {
                        fatalError("unexpected not exists last value")
                    }
                    
                    let isa = ObjectType.PBXGroup.rawValue
                    let pair: PBXPair = [
                        "isa": isa,
                        "children": [
                            childId
                        ],
                        "path": pathName,
                        "sourceTree": "<group>"
                    ]
                    
                    let uuid = generateHashId()
                    let group = PBX.Group(
                        id: uuid,
                        dictionary: pair,
                        isa: isa,
                        allPBX: allPBX
                    )
                    
                    allPBX.dictionary[uuid] = group
                    appendGroupIfNeeded(with: uuid, groupPathNames: Array(groupPathNames.dropLast()))
                }
            }
            
            appendGroupIfNeeded(with: fileRefId, groupPathNames: groupPathNames)
        }
        
        
        
        let buildFileId = generateHashId()
        func buildFile() -> PBX.BuildFile { // build file
            let isa = ObjectType.PBXBuildFile.rawValue
            let pair: PBXPair = [
                "isa": isa,
                "fileRef": fileRefId,
            ]
            
            let buildFile = PBX.BuildFile(
                id: buildFileId,
                dictionary: pair,
                isa: isa,
                allPBX: allPBX
            )
            allPBX.dictionary[buildFileId] = buildFile 
            
            return buildFile 
        }
        
        let buildedFile = buildFile()
        
        let sourceBuildPhaseId = generateHashId()
        func sourceBuildPhase() { // source build phase
            
            guard let target = allPBX
                .dictionary
                .values
                .flatMap ({ $0 as? PBX.NativeTarget })
                .filter ({ $0.name == targetName })
                .first
                else {
                    fatalError(assertionMessage(description: "Unexpected target name \(targetName)"))
            }
            
            let sourcesBuildPhase = target.buildPhases.flatMap { $0 as? PBX.SourcesBuildPhase }.first
            guard sourcesBuildPhase == nil else {
                // already exists
                sourcesBuildPhase?.files.append(buildedFile)
                return
            }
            
            let isa = ObjectType.PBXSourcesBuildPhase.rawValue
            let pair: PBXPair = [
                "isa": isa,
                "buildActionMask": Int32.max,
                "files": [
                    buildFileId
                ],
                "runOnlyForDeploymentPostprocessing": 0
            ]
            
            allPBX.dictionary[sourceBuildPhaseId] = PBX.SourcesBuildPhase(
                id: sourceBuildPhaseId,
                dictionary: pair,
                isa: isa,
                allPBX: allPBX
            )
        }
        
        sourceBuildPhase()
    }
}

extension XcodeProject {
    func write() throws {
        let serialization = XcodeSerialization(project: self)
        let writeContent = try serialization.generateWriteContent()
        func w(with code: String, fileURL: URL) throws {
            try code.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        
        let writeUrl = pbxUrl
        try w(with: writeContent, fileURL: writeUrl)
    }
}


