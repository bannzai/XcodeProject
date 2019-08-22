import XcodeProjectCore
import Commander
import Foundation

command(
    Argument<String>("pbxproj", description: "Path to project.pbxproj."),
    Argument<String>("directory", description: "Target directory name for lint project.pbxproj")
) { (pbxprojPath, directoryName) in
    let xcodeproject = try XcodeProject(xcodeprojectURL: URL(fileURLWithPath: pbxprojPath))
    try xcodeproject.sync(from: directoryName)
    }
    .run()

