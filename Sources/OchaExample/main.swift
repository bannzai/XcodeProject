import Foundation
import Ocha
import XcodeProjectCore
import Commander


command(
    Argument<String>("pbxproj", description: "Path to project.pbxproj."),
    Argument<String>("target", description: "Target name for editing project.pbxproj")
) { (pbxprojPath, targetName) in
    print("🍵 Start 🍵")
    let subpaths = try FileManager.default.subpathsOfDirectory(atPath: Process().currentDirectoryPath)
    let watcher = Watcher(paths: subpaths)
    let xcodeproject = try XcodeProject(xcodeprojectURL: URL(fileURLWithPath: pbxprojPath))
    watcher.start { (events) in
        print("🍵 Changed 🍵")
        events
            .filter { $0.flag.contains(.removedFile) }
            .forEach { event in
                print("🍵 Deleted files \(event.path) 🍵")
                xcodeproject.removeFile(path: event.path, targetName: targetName)
        }
        events
            .filter { $0.flag.contains(.createdFile) }
            .forEach { event in
                print("🍵 Appended files \(event.path) 🍵")
                xcodeproject.appendFile(path: event.path, targetName: targetName)
        }
    }
    RunLoop.current.run()
}
.run()

