//
//  XcodeProjectRepository.swift
//  XcodeProject
//
//  Created by Yudai.Hirose on 2017/10/08.
//

import Foundation

public protocol XcodeProjectRepository {
    func fetchProjectName() -> String
    func fetchXcodeProjectURL() -> URL
    func fetchAllPBX() -> AllPBX
    func fetchPBXProject() -> PBX.Project
    
    // temp:
    func fetchAllPair() -> PBXPair
}

public struct XcodeProjectRepositoryImpl {
    let xcodeprojectUrl: URL
    let allPBX = AllPBX()
    let allPair: PBXPair
    var objectsPair: [String: PBXPair] {
        let objectsPair = allPair["objects"] as! [String: PBXPair]
        return objectsPair
    }
    
    init(xcodeprojectUrl: URL) throws {
        guard
            let propertyList = try? Data(contentsOf: xcodeprojectUrl)
            else {
                throw XcodeProjectError.notExistsProjectFile
        }
        var format: PropertyListSerialization.PropertyListFormat = PropertyListSerialization.PropertyListFormat.binary
        let properties = try PropertyListSerialization.propertyList(from: propertyList, options: PropertyListSerialization.MutabilityOptions(), format: &format)
        
        guard
            let pair = properties as? PBXPair
            else {
                throw XcodeProjectError.wrongFormatFile
        }
        
        self.allPair = pair
        self.xcodeprojectUrl = xcodeprojectUrl
    }
    

}

extension XcodeProjectRepositoryImpl: XcodeProjectRepository {
    public func fetchProjectName() -> String {
        guard let projectName = xcodeprojectUrl.pathComponents[xcodeprojectUrl.pathComponents.count - 2].components(separatedBy: ".").first else {
            fatalError("No Xcode project found, please specify one")
        }
        
        return projectName
    }
    
    public func fetchXcodeProjectURL() -> URL {
        return xcodeprojectUrl
    }
    
    public func fetchAllPBX() -> AllPBX {
        setupAllPBX()
        return allPBX
    }
    
    public func fetchPBXProject() -> PBX.Project {
        guard
            let id = allPair["rootObject"] as? String,
            let projectPair = objectsPair[id]
            else {
                fatalError(
                    assertionMessage(description:
                        "unexpected for pair: \(allPair)",
                        "and objectsPair: \(objectsPair)"
                    )
                )
        }
        
        return PBX.Project(
            id: id,
            dictionary: projectPair,
            isa: ObjectType.PBXProject.rawValue,
            allPBX: allPBX
        )
    }
    
    // TODO: will delete function
    public func fetchAllPair() -> PBXPair {
        return allPair
    }
}

private extension XcodeProjectRepositoryImpl {
    func setupAllPBX() {
        objectsPair
            .forEach { (hashId, objectDictionary) in
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
        }
    }
    
}
