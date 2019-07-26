import Foundation
import Commander
import XcodeProjectCore

public struct Version: CustomStringConvertible {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public init(
        _ major: Int,
        _ minor: Int,
        _ patch: Int
        ) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public var description: String {
        return "version: \(major).\(minor).\(patch)"
    }
}


public enum CLIErrorType: Error, CustomStringConvertible {
    case requirementOption(String)
    case shouldExclusiveArgument(String, String)
    
    public var description: String {
        switch self {
        case .requirementOption(let option):
            return "Should speciify option for \(option)"
        case .shouldExclusiveArgument(let a, let b):
            return "Could not use \(a) and \(b) at the same time."
        }
    }
    
    public var localizedDescription: String {
        return description
    }
}

public struct CLI {
    public let version: Version
    public init(version: Version) {
        self.version = version
    }
    
    public func execute() {
        command(
            Argument<String>("add-file", description: "Add file to project.pbxproj."),
            Argument<String>("add-group", description: "Add file to project.pbxproj."),
            Flag("overwrite", default: false, flag: nil, description: "Overwrite project.pbxproj default is false."),
            Option<String>("pbxproj", default: "", description: "Path to project.pbxproj."),
            Option<String>("target", default: "", description: "Target name for editing project.pbxproj")
        ) { (addFileName, addGroupPath, isOverwrite, pbxprojPath, targetName) in
            let xcodeproject = try XcodeProject(xcodeprojectURL: URL(fileURLWithPath: pbxprojPath))
            
            if pbxprojPath.isEmpty {
                throw CLIErrorType.requirementOption("--pbxproj")
            }
            if targetName.isEmpty {
                throw CLIErrorType.requirementOption("--target")
            }
            if !addFileName.isEmpty && !addGroupPath.isEmpty {
                throw CLIErrorType.shouldExclusiveArgument("add-file", "add-group")
            }
            
            switch addGroupPath.isEmpty {
            case false:
                xcodeproject.appendGroup(path: addGroupPath, targetName: targetName)
                break
            case true:
                break
            }
            
            switch addFileName.isEmpty {
            case false:
                xcodeproject.appendFile(path: addFileName, targetName: targetName)
                break
            case true:
                break
            }
            
            if isOverwrite {
                try xcodeproject.write()
            }
        }.run(version.description)
    }
}
