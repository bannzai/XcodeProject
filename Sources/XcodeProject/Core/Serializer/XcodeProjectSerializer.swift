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

internal let indent = FormatterIndent.indent
internal let newLine = FormatterIndent.newLine
internal let spaceForOneline = FormatterIndent.spaceForOneline
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
    private let fieldFormatter: FieldFormatter
    public init(
        project: XcodeProject,
        fieldFormatter: FieldFormatter
        ) {
        self.project = project
        self.fieldFormatter = fieldFormatter
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
        if target.contains("echo") {
            print(target)
        }
        let regexes: [String: NSRegularExpression] = [
            "\\\"": try! NSRegularExpression(pattern: "\"", options: []),
            "\\n": try! NSRegularExpression(pattern: "\n", options: []),
            "\\r": try! NSRegularExpression(pattern: "\r", options: []),
            "\\t": try! NSRegularExpression(pattern: "\t", options: []),
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
            fatalError("unexcepct isa: \(isa)")
        }
        
        let isMultiline: Bool = isMultiLineClosure(isa)
        if let _ = pairObject as? [String] {
            return fieldFormatter.format(of: (key: objectKey, value: pairObject, isa: isa), for: level)
        } else if let pairList = pairObject as? [PBXRawMapType] {
            let content = pairList
                .map { pair -> String in
                    let generateForEachFields = pair
                        .sorted { $0.0 < $1.0 }
                        .map { key, value in
                            return """
                            \(indentClosure(level + 2))\(generateForEachField(for: (key, value), with: isa, and: level + 1))
                            """
                        }
                        .joined(separator: newLine)
                    return """
                    \(indentClosure(level + 1)){
                    \(generateForEachFields)
                    \(indentClosure(level + 1))},
                    """
                }
                .joined(separator: "")
            
            return """
            \(objectKey) = (
            \(content)
            \(indentClosure(level)));
            """
        } else if let pair = pairObject as? PBXRawMapType {
            let top = indentClosure(level + 1)
            let content = pair
                .sorted { $0.0 < $1.0 }
                .compactMap { key, value in
                    return top + generateForEachField(for: (key, value), with: isa, and: level + 1)
                }
                .joined(separator: newLine)
            return """
            \(objectKey) = {
            \(content)
            \(indentClosure(level))};
            """
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
        let eachObjectPairContent = objects
            .sorted { $0.id < $1.id }
            .map { object -> String in
                let isMultiline = isMultiLineClosure(isa)
                let comment = wrapComment(for: object.id)
                let isaValue = "isa = \(isa.rawValue);"
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
                switch isMultiline {
                case true:
                    return """
                    \(indentClosure(2))\(object.id)\(comment) = {
                    \(indentClosure(3))\(isaValue)
                    \(objectPair)
                    \(indentClosure(2))};
                    """
                case false:
                    return """
                    \(indentClosure(2))\(object.id)\(comment) = {\(isaValue)\(spaceForOneline)\(objectPair)};
                    """
                }
            }
            .joined(separator: newLine)
        
        return """
        /* Begin \(isa.rawValue) section */
        \(eachObjectPairContent)
        /* End \(isa.rawValue) section */
        
        """
    }
    
    
    func generateWriteContent() -> String {
        let content = project.fullPair
            .sorted { $0.0 < $1.0 }
            .reduce("") { (lines, pair: (key: String, _: Any)) in
                let objectKey = pair.key
                switch objectKey {
                case "objects":
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
                    let row = """
                    \(indent)objects = {
                    
                    \(objectsContent)\(indent)};
                    
                    """
                    return lines + row
                case _:
                    let comment = wrapComment(for: objectKey)
                    let row = "\(objectKey) = \(project.fullPair[objectKey]!)\(comment);"
                    let content = row
                        .components(separatedBy: newLine)
                        .map { r in
                            return indent + r
                        }
                        .joined(separator: newLine)
                    
                    return lines + content + newLine
                }
        }
        return """
        // !$*UTF8*$!
        {
        \(content)}
        
        """
    }
}
