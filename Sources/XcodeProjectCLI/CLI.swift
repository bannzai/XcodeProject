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
            Option<String>("add-file", default: "", description: "Add file to project.pbxproj. The file must exists."),
            Option<String>("add-group", default: "", description: "Add group to project.pbxproj. The directory of group must exists."),
            Flag("overwrite", default: false, flag: nil, description: "Overwrite project.pbxproj default is false."),
            Argument<String>("pbxproj", description: "Path to project.pbxproj."),
            Argument<String>("target", description: "Target name for editing project.pbxproj")
        ) { (addFileName, addGroupPath, isOverwrite, pbxprojPath, targetName) in
            let xcodeproject = try XcodeProject(xcodeprojectURL: URL(fileURLWithPath: pbxprojPath))
            
            if pbxprojPath.isEmpty {
                throw CLIErrorType.requirementOption("--pbxproj")
            }
            if targetName.isEmpty {
                throw CLIErrorType.requirementOption("--target")
            }
            if addFileName.isEmpty && addGroupPath.isEmpty {
                throw CLIErrorType.shouldExclusiveArgument("--add-file", "--add-group")
            }
            
            switch addGroupPath.isEmpty {
            case false:
                print("♻️  Append \(addGroupPath) to \(targetName).")
                xcodeproject.appendGroup(path: addGroupPath, targetName: targetName)
                break
            case true:
                break
            }
            
            switch addFileName.isEmpty {
            case false:
                print("♻️  Append \(addFileName) to \(targetName).")
                xcodeproject.appendFile(path: addFileName, targetName: targetName)
                break
            case true:
                break
            }
            
            if isOverwrite {
                print("📝 Overwrite \(pbxprojPath).")
                try xcodeproject.write()
            }
        }.run(version.description)
    }
}
