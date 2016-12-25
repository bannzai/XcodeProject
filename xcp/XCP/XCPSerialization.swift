//
//  XCPSerialization.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/12/23.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

public class XCPSerialization {
    fileprivate let indent = "\t"
    fileprivate let newLine = "\n"
    fileprivate let spaceForOneline = " "
    fileprivate var indentClosure: ((Int) -> String) = { num in
        var ret = ""
        for _ in 0..<num {
            ret += "\t"
        }
        return ret
    }
    
    fileprivate let isMultiLineClosure: ((ObjectType) -> Bool) = { isa in
        switch isa {
        case .PBXBuildFile, .PBXFileReference:
            return false
        default:
            return true
        }
    }
    
    fileprivate lazy var buildPhaseByFileId: [String: PBX.BuildPhase] = {
        let buildPhases = self.project.allPBX.dictionary
            .values
            .flatMap { $0 as? PBX.BuildPhase }
        
        var dictionary: [String: PBX.BuildPhase] = [:]
        buildPhases.forEach { buildPhase in
            buildPhase.files.forEach { file in
                dictionary[file.id] = buildPhase
            }
        }
        
        return dictionary
    }()
    
    
    fileprivate lazy var targetsByConfigId: [String: PBX.NativeTarget] = {
        var dictionary: [String: PBX.NativeTarget] = [:]
        for target in self.project.project.targets {
            dictionary[target.buildConfigurationList.id] = target
        }
        
        return dictionary
    }()
    
    let project: XCProject
    
    init(project: XCProject) {
        self.project = project
    }
    
}
extension XCPSerialization {
    func escapeIfNeeded(with target: String) throws -> String {
        let regexes = [
            "\\\\": try! NSRegularExpression(pattern: "\\\\", options: []),
            "\\\"": try! NSRegularExpression(pattern: "\"", options: []),
            "\\n": try! NSRegularExpression(pattern: "\\n", options: []),
            "\\r": try! NSRegularExpression(pattern: "\\r", options: []),
            "\\t": try! NSRegularExpression(pattern: "\\t", options: []),
            ]
        
        var str = target
        for (replacement, regex) in regexes {
            let range = NSRange(location: 0, length: str.utf16.count)
            let template = NSRegularExpression.escapedTemplate(for: replacement)
            str = regex.stringByReplacingMatches(in: str, options: [], range: range, withTemplate: template)
        }
        
        let noEscapeRegex = try NSRegularExpression(pattern: "^[a-z0-9_\\.\\/]+$", options: NSRegularExpression.Options.caseInsensitive)
        if noEscapeRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) == nil {
            return "\"\(str)\""
        }
        return str
    }
    
    func commentValue(for hashId: String) -> String {
        if hashId == "rootObject" {
            return "Project object"
        }
        
        if project.project.id == hashId {
            return "Project object"
        }
        
        guard let object = project.allPBX.dictionary[hashId] else {
            return ""
        }
        
        switch object {
        case let o as PBX.Reference:
            return o.name ?? o.path ?? ""
        case let o as PBX.Target:
            return o.name
        case let o as XC.BuildConfiguration:
            return o.name
        case let o as PBX.CopyFilesBuildPhase:
            return o.name ?? "CopyFiles"
        case is PBX.FrameworksBuildPhase:
            return "Frameworks"
        case is PBX.HeadersBuildPhase:
            return "Headers"
        case is PBX.ResourcesBuildPhase:
            return "Resources"
        case let o as PBX.ShellScriptBuildPhase:
            return o.name ?? "ShellScript"
        case is PBX.SourcesBuildPhase:
            return "Sources"
        case is PBX.ContainerItemProxy:
            return "PBXContainerItemProxy"
        case is PBX.TargetDependency:
            return "PBXTargetDependency"
        case let o as PBX.BuildFile where buildPhaseByFileId[hashId] != nil:
            let buildPhase = buildPhaseByFileId[hashId]!
            let group = commentValue(for: buildPhase.id)
            let fileRef = commentValue(for: o.fileRef.id)
            return  "\(fileRef) in \(group)"
        case is XC.ConfigurationList where targetsByConfigId[hashId] != nil:
            let target = targetsByConfigId[hashId]!
            return "Build configuration list for \(target.isa) \"\(target.name)\""
        case is XC.ConfigurationList:
            return "Build configuration list for PBXProject \"\(project.projectName)\""
        default:
            return ""
        }
    }
    
    func wrapComment(for isa: String) -> String {
        let comment = commentValue(for: isa)
        if comment.isEmpty {
            return ""
        }
        return " /* \(comment) */"
    }
    
    func jsonString(for pair: (objectKey: String, jsonObject: Any), with isa: ObjectType, and level: Int) -> String {
        let objectKey = try! escapeIfNeeded(with: pair.objectKey)
        let jsonObject = pair.jsonObject
        
        if objectKey == "isa" {
            // skip
            fatalError("unexcepct isa: \(isa)")
        }
        
        let isMultiline: Bool = isMultiLineClosure(isa)
        if let objectIds = jsonObject as? [String] {
            let begin = "\(objectKey) = (" + (isMultiline ? newLine : "")
            let content = objectIds.map { "\(indentClosure(isMultiline ? level + 1 : 0))\(try! escapeIfNeeded(with: $0))\(wrapComment(for: try! escapeIfNeeded(with: $0)))," }.joined(separator: (isMultiline ? newLine : spaceForOneline))
            let end = ");"
            return begin + content + (objectIds.isEmpty ? "" : (isMultiline ? newLine: spaceForOneline)) + indentClosure(isMultiline ? level : 0) + end + (isMultiline ? "" : spaceForOneline)
        } else if let jsonList = jsonObject as? [XCProject.JSON] {
            let begin = "\(objectKey) = ("
            let content = jsonList.flatMap { json -> [String] in
                let top = isMultiline ? indentClosure(isMultiline ? level + 2 : 0) : ""
                let period = isMultiline ? "\(indentClosure(isMultiline ? level + 1 : 0))}," : "} "
                let jsonStrings = json.sorted { $0.0 < $1.0 }.map { key, value in
                    return top + jsonString(for: (key, value), with: isa, and: level + 1)
                }
                return [newLine + indentClosure(isMultiline ? level + 1 : 0) + "{" + newLine] + jsonStrings.map { $0 + newLine } + [period]
                }.joined(separator: "")
            let end = ");"
            return begin + content + newLine + indentClosure(isMultiline ? level : 0) + end
        } else if let json = jsonObject as? XCProject.JSON {
            let begin = "\(objectKey) = {"
            let top = isMultiline ? indentClosure(isMultiline ? level + 1 : 0) : ""
            let content = json.sorted { $0.0 < $1.0 }.flatMap { key, value in
                return top + jsonString(for: (key, value), with: isa, and: level + 1)
                }.joined(separator: (isMultiline ? newLine: ""))
            let end = "};"
            return begin + (isMultiline ? newLine: "") + content + (isMultiline ? newLine : "") + indentClosure(isMultiline ? level : 0) + end + (isMultiline ? "" : spaceForOneline)
        } else {
            let string = try! escapeIfNeeded(with: "\(jsonObject)")
            let isNeedComment = !(objectKey == "remoteGlobalIDString" || objectKey == "TestTargetID")
            let comment = isNeedComment ? wrapComment(for: string) : ""
            let space = isMultiline ? "" : spaceForOneline
            let content = "\(objectKey) = \(string)\(comment);\(space)"
            return content
        }
    }
    
    fileprivate func generateContentEachSection(for pairFor: (isa: ObjectType, objects: [PBX.Object])) throws -> String {
        let isa = pairFor.isa
        let objects = pairFor.objects
        
        let beginSection = "/* Begin \(isa.rawValue) section */"
        let eachObjectJsonContent = objects
            .sorted { $0.id < $1.id }
            .map { object -> String in
                let comment = wrapComment(for: object.id)
                let begin = "\(object.id)\(comment) = {"
                let end = "};"
                let isMultiline = isMultiLineClosure(isa)
                let isaSpace = isMultiline ? "" : spaceForOneline
                let isaValue = "isa = \(isa.rawValue);" + isaSpace
                let objectJson = object.objectDictionary
                    .sorted { $0.0 < $1.0 }
                    .flatMap { (key: String, value: Any) -> String? in
                        if key == "isa" {
                            // skip
                            return nil
                        }
                        
                        let content = jsonString(for: (key, value), with: isa, and: 3)
                        if content.isEmpty {
                            return nil
                        }
                        return indentClosure(isMultiline ? 3 : 0) + content
                    }.joined(separator: isMultiline ? newLine : "")
                
                return indentClosure(2)
                    + begin
                    + (isMultiline ? newLine : "")
                    + indentClosure(isMultiline ? 3 : 0)
                    + isaValue
                    + (isMultiline ? newLine : "")
                    + objectJson
                    + (isMultiline ? newLine : "")
                    + indentClosure(isMultiline ? 2 : 0)
                    + end
            }.joined(separator: newLine)
        
        let endSection = "/* End \(isa.rawValue) section */"
        return beginSection + newLine + eachObjectJsonContent + newLine + endSection + newLine
    }
    
    public func generateWriteContent() throws -> String {
        let beginWriteCotent = "// !$*UTF8*$!\(newLine){\(newLine)"
        let endWriteContent = "}\(newLine)"
        return try beginWriteCotent
            + project.fullJson
                .sorted { $0.0 < $1.0 }
                .reduce("") { (lines, pair: (key: String, value: Any)) in
                    let objectKey = pair.key
                    if objectKey == "objects" {
                        let beginObjects = indent + "objects = {" + newLine
                        let groupedObject = project.allPBX.dictionary
                            .values
                            .toArray()
                            .groupBy { $0.isa.rawValue }
                        
                        let objectsContent = try groupedObject
                            .keys
                            .sorted()
                            .map { isa in
                                return (ObjectType(for: isa), groupedObject[isa]!)
                            }
                            .map { isa, objects -> String in
                                return try generateContentEachSection(for: (isa, objects))
                            }.joined(separator: newLine)
                        
                        let endObjects = "};"
                        return lines +  beginObjects + newLine + objectsContent + indent + endObjects + newLine
                    } else {
                        let comment = wrapComment(for: objectKey)
                        let row = "\(objectKey) = \(project.fullJson[objectKey]!)\(comment);"
                        let content = row.components(separatedBy: newLine).map { r in
                            return indent + r
                            }.joined(separator: newLine)
                        
                        return lines + content + newLine
                    }
            } + endWriteContent
    }
    
}
