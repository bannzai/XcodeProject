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
            Option<String>("add-file", default: "", description: "Add file to project.pbxproj with relative file path. The file must exists."),
            Option<String>("add-group", default: "", description: "Add group to project.pbxproj with relative directory path. The directory of group must exists."),
            Option<String>("remove-file", default: "", description: "Remove file to project.pbxproj with relative file path. The file must exists."),
            Option<String>("remove-group", default: "", description: "Remove file to project.pbxproj with relative file path. The file must exists."),
            Flag("print", default: false, flag: nil, description: "Printing result for changed project.pbxproj. When print is true not overwrite project.pbxproj. Default is false."),
            Argument<String>("pbxproj", description: "Path to project.pbxproj."),
            Argument<String>("target", description: "Target name for editing project.pbxproj")
        ) { (addFilePath, addGroupPath, removeFilePath, removeGroupPath, isPrint, pbxprojPath, targetName) in
            let xcodeproject = try XcodeProject(xcodeprojectURL: URL(fileURLWithPath: pbxprojPath))
            
            if pbxprojPath.isEmpty {
                throw CLIErrorType.requirementOption("--pbxproj")
            }
            if targetName.isEmpty {
                throw CLIErrorType.requirementOption("--target")
            }
            if !addFilePath.isEmpty && !addGroupPath.isEmpty {
                throw CLIErrorType.shouldExclusiveArgument("--add-file", "--add-group")
            }
            if !removeFilePath.isEmpty && !removeGroupPath.isEmpty {
                throw CLIErrorType.shouldExclusiveArgument("--remove-file", "--remove-group")
            }
            
            switch removeFilePath.isEmpty {
            case false:
                print("🗑️  Remove \(removeFilePath) to \(targetName).")
                xcodeproject.removeFile(path: removeFilePath, targetName: targetName)
                break
            case true:
                break
            }
            
            switch removeGroupPath.isEmpty {
            case false:
                print("🗑️  Remove \(removeGroupPath) to \(targetName).")
                xcodeproject.removeGroup(path: removeGroupPath)
                break
            case true:
                break
            }

            switch addGroupPath.isEmpty {
            case false:
                print("♻️  Append \(addGroupPath) to \(targetName).")
                xcodeproject.appendGroup(path: addGroupPath, targetName: targetName)
                break
            case true:
                break
            }
            
            switch addFilePath.isEmpty {
            case false:
                print("♻️  Append \(addFilePath) to \(targetName).")
                xcodeproject.appendFile(path: addFilePath, targetName: targetName)
                break
            case true:
                break
            }
            
            switch isPrint {
            case true:
                let output = XcodeProjectSerializer().serialize(project: xcodeproject)
                print(output)
            case false:
                print("📝 Overwrite \(pbxprojPath).")
                try xcodeproject.write()
            }
        }.run(version.description)
    }
}
