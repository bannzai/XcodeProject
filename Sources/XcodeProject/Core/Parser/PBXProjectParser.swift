//
//  PBXProjectParser.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public struct PBXProjectRawValue {
    let xcodeprojectUrl: URL
    let allPair: PBXPair

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
                throw XcodeProjectError.wrongFileFormat
        }
        
        self.allPair = pair
        self.xcodeprojectUrl = xcodeprojectUrl
    }
}

public protocol PBXProjectParser {
    
}

public struct PBXProjectParserImpl: PBXProjectParser {
    let raw: PBXProjectRawValue
    var objects: [String: PBXPair] {
        let objectsPair = raw.allPair["objects"] as! [String: PBXPair]
        return objectsPair
    }

    func projectName() throws -> String {
        guard let xcodeProjFile = raw
                .xcodeprojectUrl
                .pathComponents
                .dropLast() // drop project.pbxproj
                .last // get PROJECTNAME.xcodeproj
            else {
                throw XcodeProjectError.missingReadFile
        }
        
        guard let projectName = xcodeProjFile.components(separatedBy: ".").first else {
            throw XcodeProjectError.wrongFileFormat
        }

        return projectName
    }
    
    func rootObject(with context: Context) -> PBX.Project {
        guard
            let id = raw.allPair["rootObject"] as? String,
            let projectPair = objects[id]
            else {
                fatalError(
                    assertionMessage(description:
                        "unexpected for pair: \(raw.allPair)",
                        "and objectsPair: \(objects)"
                    )
                )
        }
        
        return PBX.Project(
            id: id,
            dictionary: projectPair,
            isa: ObjectType.PBXProject.rawValue,
            allPBX: context
        )
    }
    
    func context() -> Context {
        let context = Context()
        objects
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
                    allPBX: context
                )
                
                context.dictionary[hashId] = pbxObject
        }
        return context
    }
}
