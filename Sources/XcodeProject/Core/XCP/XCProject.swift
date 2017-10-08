//
//
//  XCProject.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/20.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

open class XCProject {
    public typealias JSON = [String: Any]
    public typealias KeyAndValue = [(key: String, value: Any)]
    
    open let projectName: String
    open let fullJson: JSON
    open let allPBX = AllPBX()
    open let project: PBX.Project
    open let pbxUrl: URL
    open fileprivate(set) var environments: [String: String] = [:]
    
    public init(for pbxUrl: URL) throws {
        guard
            let propertyList = try? Data(contentsOf: pbxUrl)
            else {
                throw XCProjectError.notExistsProjectFile
        }
        var format: PropertyListSerialization.PropertyListFormat = PropertyListSerialization.PropertyListFormat.binary
        let properties = try PropertyListSerialization.propertyList(from: propertyList, options: PropertyListSerialization.MutabilityOptions(), format: &format)
        
        guard
            let json = properties as? JSON
            else {
                throw XCProjectError.wrongFormatFile
        }
        
        func generateObjects(with objectsJson: [String: JSON], allPBX: AllPBX) -> [PBX.Object] {
            return objectsJson
                .flatMap { (hashId, objectDictionary) in
                    guard
                        let isa = objectDictionary["isa"] as? String
                        else {
                            fatalError(
                                assertionMessage(description:
                                    "not exists isa key: \(hashId), value: \(objectDictionary)",
                                    "you should check for project.pbxproj that is correct."
                                )
                            )
                    }
                    
                    let pbxType = ObjectType.type(with: isa)
                    
                    let pbxObject = pbxType.init(
                        id: hashId,
                        dictionary: objectDictionary,
                        isa: isa,
                        allPBX: allPBX
                    )
                    
                    allPBX.dictionary[hashId] = pbxObject
                    
                    return pbxObject
            }
        }
        func generateProject(with objectsJson: [String: JSON], allPBX: AllPBX) -> PBX.Project {
            guard
                let id = json["rootObject"] as? String,
                let projectJson = objectsJson[id]
                else {
                    fatalError(
                        assertionMessage(description:
                            "unexpected for json: \(json)",
                            "and objectsJson: \(objectsJson)"
                        )
                    )
            }
            return PBX.Project(
                id: id,
                dictionary: projectJson,
                isa: ObjectType.PBXProject.rawValue,
                allPBX: allPBX
            )
        }
        
        self.pbxUrl = pbxUrl
        guard let projectName = pbxUrl.pathComponents[pbxUrl.pathComponents.count - 2].components(separatedBy: ".").first else {
            fatalError("No Xcode project found, please specify one")
        }
        self.projectName = projectName
        fullJson = json
        let objectsJson = json["objects"] as! [String: JSON]
        _ = generateObjects(with: objectsJson, allPBX: allPBX)
        project = generateProject(with: objectsJson, allPBX: allPBX)
        allPBX.resetFullFilePaths(with: project)
    }
    
    // MARK: - enviroment
    open func append(with enviroment: [String: String]) {
        environments += enviroment
    }
    
    open func isExists(for environment: Environment) -> Bool {
        return environments[environment.rawValue] != nil
    }
    
    fileprivate func environment(for key: String) -> Environment {
        guard
            let value = environments[key],
            let environment = Environment(rawValue: value)
            else {
                fatalError(
                    assertionMessage(description:
                        "unknown key: \(key)",
                        "process environments: \(environments)"
                    )
                )
        }
        return environment 
    }
    
    fileprivate func url(from environment: Environment) -> URL {
        guard
            let path = environments[environment.rawValue]
            else {
                fatalError(assertionMessage(description: "can not cast environment: \(environment)"))
        }
        
        return URL(fileURLWithPath: path)
    }
    
    open func path(from component: PathComponent) -> URL {
        switch component {
        case .simple(let fullPath):
            return URL(fileURLWithPath: fullPath)
        case .environmentPath(let environtment, let relativePath):
            let _url = url(from: environtment)
                .appendingPathComponent(relativePath)
            return _url
        }
    }
}

extension XCProject {
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
            let json: XCProject.JSON = [
                "isa": isa,
                "fileEncoding": 4,
                "lastKnownFileType": LastKnownFileType(fileName: fileName).value,
                "path": fileName,
                "sourceTree": "<group>"
            ]
            
            fileRef = PBX.FileReference(
                id: fileRefId,
                dictionary: json,
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
                    let json: XCProject.JSON = [
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
                        dictionary: json,
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
            let json: XCProject.JSON = [
                "isa": isa,
                "fileRef": fileRefId,
            ]
            
            let buildFile = PBX.BuildFile(
                id: buildFileId,
                dictionary: json,
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
            let json: XCProject.JSON = [
                "isa": isa,
                "buildActionMask": Int32.max,
                "files": [
                    buildFileId
                ],
                "runOnlyForDeploymentPostprocessing": 0
            ]
            
            allPBX.dictionary[sourceBuildPhaseId] = PBX.SourcesBuildPhase(
                id: sourceBuildPhaseId,
                dictionary: json,
                isa: isa,
                allPBX: allPBX
            )
        }
        
        sourceBuildPhase()
    }
}

extension XCProject {
    func write() throws {
        let serialization = XCPSerialization(project: self)
        let writeContent = try serialization.generateWriteContent()
        func w(with code: String, fileURL: URL) throws {
            try code.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        
        let writeUrl = pbxUrl
        try w(with: writeContent, fileURL: writeUrl)
    }
}


