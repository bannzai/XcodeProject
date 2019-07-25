//
//  SerializeFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public protocol SerializeFormatter: AutoMockable {
    
}

// MARK: - Serializer formatter helper functions
public struct FormatterIndent {
    static internal let indent = "\t"
    static internal let newLine = "\n"
    static internal let spaceForOneline = " "
}

internal let indent = FormatterIndent.indent
internal let newLine = FormatterIndent.newLine
internal let spaceForOneline = FormatterIndent.spaceForOneline

extension SerializeFormatter {
    func indent(_ level: Int) -> String {
        var ret = ""
        for _ in 0..<level {
            ret += FormatterIndent.indent
        }
        return ret
    }
    
    func isMultiLine(_ isa: ObjectType) -> Bool {
        switch isa {
        case .PBXBuildFile, .PBXFileReference:
            return false
        default:
            return true
        }
    }

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
    
    
    func commentValue(context: Context, for hashId: String) -> String {
        if hashId == "rootObject" {
            return "Project object"
        }
        
        if context.rootID == hashId {
            return "Project object"
        }
        
        guard let object = context.objects[hashId] else {
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
        case let o as PBX.BuildFile:
            if let buildPhase = buildPhaseByFileId(context: context)[hashId] {
                let group = commentValue(context: context, for: buildPhase.id)
                let fileRef = commentValue(context: context, for: o.fileRef.id)
                return  "\(fileRef) in \(group)"
            }
            return ""
        case is XC.ConfigurationList:
            if let target = targetsByConfigId(context: context)[hashId] {
                return "Build configuration list for \(target.isa) \"\(target.name)\""
            }
            return "Build configuration list for PBXProject \"\(context.extractProjectName())\""
        default:
            return ""
        }
    }
    
    func wrapComment(context: Context, for isa: String) -> String {
        let comment = commentValue(context: context, for: isa)
        if comment.isEmpty {
            return ""
        }
        return " /* \(comment) */"
    }
    
    func buildPhaseByFileId(context: Context) -> [String: PBX.BuildPhase]  {
        let buildPhases = context.objects
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
    
    
    func targetsByConfigId(context: Context) -> [String: PBX.NativeTarget] {
        var dictionary: [String: PBX.NativeTarget] = [:]
        for target in context.extractPBXProject().targets {
            dictionary[target.buildConfigurationList.id] = target
        }
        
        return dictionary
    }
}
