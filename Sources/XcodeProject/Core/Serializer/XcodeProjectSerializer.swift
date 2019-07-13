//
//  XcodeProjectSerializer.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol Serializer {
    func serialize() -> String
}

internal let indent = "\t"
internal let newLine = "\n"
internal let spaceForOneline = " "
public struct XcodeProjectSerializer {
    private var indentClosure: ((Int) -> String) = { num in
        var ret = ""
        for _ in 0..<num {
            ret += indent
        }
        return ret
    }
    
    private let isMultiLineClosure: ((ObjectType) -> Bool) = { isa in
        switch isa {
        case .PBXBuildFile, .PBXFileReference:
            return false
        default:
            return true
        }
    }
    
    private func buildPhaseByFileId() -> [String: PBX.BuildPhase]  {
        let buildPhases = self.project.allPBX.dictionary
            .values
            .compactMap { $0 as? PBX.BuildPhase }
        
        var dictionary: [String: PBX.BuildPhase] = [:]
        buildPhases.forEach { buildPhase in
            buildPhase.files.forEach { file in
                dictionary[file.id] = buildPhase
            }
        }
        
        return dictionary
    }
    
    
    private func targetsByConfigId() -> [String: PBX.NativeTarget] {
        var dictionary: [String: PBX.NativeTarget] = [:]
        for target in self.project.project.targets {
            dictionary[target.buildConfigurationList.id] = target
        }
        
        return dictionary
    }
    
    private let project: XcodeProject
    public init(project: XcodeProject) {
        self.project = project
    }
}

extension XcodeProjectSerializer: Serializer {
    public func serialize() -> String {
        return generateWriteContent()
    }
}

// MARK: - Internal
internal extension XcodeProjectSerializer {
    func escape(with target: String) throws -> String {
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
        if noEscapeRegex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.count)) == nil {
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
        case let o as PBX.BuildFile where buildPhaseByFileId()[hashId] != nil:
            let buildPhase = buildPhaseByFileId()[hashId]!
            let group = commentValue(for: buildPhase.id)
            let fileRef = commentValue(for: o.fileRef.id)
            return  "\(fileRef) in \(group)"
        case is XC.ConfigurationList where targetsByConfigId()[hashId] != nil:
            let target = targetsByConfigId()[hashId]!
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
    
    func generateForEachField(for pair: (objectKey: String, pairObject: Any), with isa: ObjectType, and level: Int) -> String {
        let objectKey = try! escape(with: pair.objectKey)
        let pairObject = pair.pairObject
        
        if objectKey == "isa" {
            // skip
            fatalError("unexcepct isa: \(isa)")
        }
        
        let isMultiline: Bool = isMultiLineClosure(isa)
        if let objectIds = pairObject as? [String] {
            let begin = "\(objectKey) = (" + (isMultiline ? newLine : "")
            let content = objectIds
                .map { "\(indentClosure(isMultiline ? level + 1 : 0))\(try! escape(with: $0))\(wrapComment(for: try! escape(with: $0)))," }
                .joined(separator: (isMultiline ? newLine : spaceForOneline))
            let end = ");"
            return begin + content + (objectIds.isEmpty ? "" : (isMultiline ? newLine: spaceForOneline)) + indentClosure(isMultiline ? level : 0) + end + (isMultiline ? "" : spaceForOneline)
        } else if let pairList = pairObject as? [PBXPair] {
            let begin = "\(objectKey) = ("
            let content = pairList
                .flatMap { pair -> [String] in
                    let top = isMultiline ? indentClosure(isMultiline ? level + 2 : 0) : ""
                    let period = isMultiline ? "\(indentClosure(isMultiline ? level + 1 : 0))}," : "} "
                    let generateForEachFields = pair.sorted { $0.0 < $1.0 }.map { key, value in
                        return top + generateForEachField(for: (key, value), with: isa, and: level + 1)
                    }
                    let begin = [newLine + indentClosure(isMultiline ? level + 1 : 0) + "{" + newLine]
                    let content = generateForEachFields.map { $0 + newLine }
                    let end = [period]
                    return begin + content + end
                }
                .joined(separator: "")
            let end = ");"
            return begin + content + newLine + indentClosure(isMultiline ? level : 0) + end
        } else if let pair = pairObject as? PBXPair {
            let begin = "\(objectKey) = {"
            let top = isMultiline ? indentClosure(isMultiline ? level + 1 : 0) : ""
            let content = pair
                .sorted { $0.0 < $1.0 }
                .compactMap { key, value in
                    return top + generateForEachField(for: (key, value), with: isa, and: level + 1)
                }
                .joined(separator: (isMultiline ? newLine: ""))
            let end = "};"
            return begin + (isMultiline ? newLine: "") + content + (isMultiline ? newLine : "") + indentClosure(isMultiline ? level : 0) + end + (isMultiline ? "" : spaceForOneline)
        } else {
            let string = try! escape(with: "\(pairObject)")
            let isNeedComment = !(objectKey == "remoteGlobalIDString" || objectKey == "TestTargetID")
            let comment = isNeedComment ? wrapComment(for: string) : ""
            let space = isMultiline ? "" : spaceForOneline
            let content = "\(objectKey) = \(string)\(comment);\(space)"
            return content
        }
    }
    
    func generateContentEachSection(isa: ObjectType, objects: [PBX.Object]) -> String {
        let beginSection = "/* Begin \(isa.rawValue) section */"
        let eachObjectPairContent = objects
            .sorted { $0.id < $1.id }
            .map { object -> String in
                let comment = wrapComment(for: object.id)
                let begin = "\(object.id)\(comment) = {"
                let end = "};"
                let isMultiline = isMultiLineClosure(isa)
                let isaSpace = isMultiline ? "" : spaceForOneline
                let isaValue = "isa = \(isa.rawValue);" + isaSpace
                let objectPair = object.objectDictionary
                    .sorted { $0.0 < $1.0 }
                    .compactMap { (key: String, value: Any) -> String? in
                        if key == "isa" {
                            // skip
                            return nil
                        }
                        
                        let content = generateForEachField(for: (key, value), with: isa, and: 3)
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
                    + objectPair
                    + (isMultiline ? newLine : "")
                    + indentClosure(isMultiline ? 2 : 0)
                    + end
            }
            .joined(separator: newLine)
        
        let endSection = "/* End \(isa.rawValue) section */"
        return beginSection + newLine + eachObjectPairContent + newLine + endSection + newLine
    }
    

    func generateWriteContent() -> String {
        let beginWriteCotent = "// !$*UTF8*$!\(newLine){\(newLine)"
        let endWriteContent = "}\(newLine)"
        return beginWriteCotent
            + project.fullPair
                .sorted { $0.0 < $1.0 }
                .reduce("") { (lines, pair: (key: String, _: Any)) in
                    let objectKey = pair.key
                    if objectKey == "objects" {
                        let beginObjects = indent + "objects = {" + newLine
                        let groupedObject = project.allPBX.dictionary
                            .values
                            .toArray()
                            .groupBy { $0.isa.rawValue }
                        
                        let objectsContent = groupedObject
                            .keys
                            .sorted()
                            .map { isa in
                                return (ObjectType(for: isa), groupedObject[isa]!)
                            }
                            .map { isa, objects -> String in
                                return generateContentEachSection(isa: isa, objects: objects)
                            }
                            .joined(separator: newLine)
                        
                        let endObjects = "};"
                        return lines +  beginObjects + newLine + objectsContent + indent + endObjects + newLine
                    } else {
                        let comment = wrapComment(for: objectKey)
                        let row = "\(objectKey) = \(project.fullPair[objectKey]!)\(comment);"
                        let content = row.components(separatedBy: newLine).map { r in
                            return indent + r
                            }.joined(separator: newLine)
                        
                        return lines + content + newLine
                    }
            } + endWriteContent
    }
}
