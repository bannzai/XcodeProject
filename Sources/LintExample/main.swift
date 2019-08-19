import XcodeProjectCore
import Commander
import Foundation

command(
    Argument<String>("pbxproj", description: "Path to project.pbxproj."),
    Argument<String>("target", description: "Target name for editing project.pbxproj")
) { (pbxprojPath, targetName) in
    print("🍵 Start 🍵")
    let subpaths = try FileManager.default.subpathsOfDirectory(atPath: Process().currentDirectoryPath)
    let xcodeproject = try XcodeProject(xcodeprojectURL: URL(fileURLWithPath: pbxprojPath))
    RunLoop.current.run()
    }
    .run()

