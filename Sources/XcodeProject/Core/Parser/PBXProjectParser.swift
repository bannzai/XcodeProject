//
//  PBXProjectParser.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol Parser {
    func pair() -> PBXRawMapType
    func projectURL() -> URL
    func projectName() -> String
    func rootObject(with context: Context) -> PBX.Project
    func context() -> Context
}

public class PBXProjectParser {
    private var cachedContext: Context?
    private let xcodeprojectUrl: URL
    private let allPair: PBXRawMapType
    private var objects: [String: PBXRawMapType] {
        let objectsPair = allPair["objects"] as! [String: PBXRawMapType]
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
            let pair = properties as? PBXRawMapType
            else {
                throw XcodeProjectError.wrongFileFormat
        }
        
        self.allPair = pair
        self.xcodeprojectUrl = xcodeprojectUrl
    }
}

extension PBXProjectParser: Parser {
    public func pair() -> PBXRawMapType {
        return allPair
    }
    
    public func projectURL() -> URL {
        return xcodeprojectUrl
    }
    public func projectName() -> String {
        guard let xcodeProjFile = xcodeprojectUrl
                .pathComponents
                .dropLast() // drop project.pbxproj
                .last // get PROJECTNAME.xcodeproj
            else {
                fatalError("No Xcode project found from \(xcodeprojectUrl.absoluteString), please specify one")
        }
        
        guard let projectName = xcodeProjFile.components(separatedBy: ".").first else {
            fatalError("Can not get project name from \(xcodeProjFile)")
        }

        return projectName
    }
    
    public func rootObject(with context: Context) -> PBX.Project {
        guard
            let id = allPair["rootObject"] as? String,
            let projectPair = objects[id]
            else {
                fatalError(
                    assertionMessage(description:
                        "unexpected for pair: \(allPair)",
                        "and objectsPair: \(objects)"
                    )
                )
        }
        
        return PBX.Project(
            id: id,
            dictionary: projectPair,
            isa: ObjectType.PBXProject.rawValue,
            context: context
        )
    }
    
    public func context() -> Context {
        if let context = cachedContext {
            return context
        }
        
        let context = InternalContext()
        defer {
            cachedContext = context
        }
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
                    context: context
                )
                
                context.dictionary[hashId] = pbxObject
        }
        context.resetFullFilePaths(with: rootObject(with: context))
        return context
    }
}
