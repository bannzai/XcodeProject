import Foundation
import Ocha
import XcodeProjectCore
import Commander


func toRelativePath(_ path: String) -> String {
    let pwd = Process().currentDirectoryPath + "/"
    return String(path.suffix(from: pwd.endIndex))
}

command(
    Argument<String>("pbxproj", description: "Path to project.pbxproj."),
    Argument<String>("target", description: "Target name for editing project.pbxproj")
) { (pbxprojPath, targetName) in
    print("🍵 Start 🍵")
    let subpaths = try FileManager.default.subpathsOfDirectory(atPath: Process().currentDirectoryPath)
    let watcher = Watcher(paths: subpaths)
    let xcodeproject = try XcodeProject(xcodeprojectURL: URL(fileURLWithPath: pbxprojPath))
    watcher.start { (events) in
        print("🍵 Changed \(events) 🍵")
        let events = events.filter { $0.path.hasSuffix(".swift") }.map { (flag: $0.flag, path: toRelativePath($0.path)) }
        print("🍵 Filtered \(events) 🍵")
        
        do {
            try events
                .filter { $0.flag == [.removedFile, .itemIsFile] }
                .forEach { event in
                    print("🍵 Deleted files \(event.path) 🍵")
                    xcodeproject.removeFile(path: event.path, targetName: targetName)
                    try xcodeproject.write()
            }
        } catch {
            print(error.localizedDescription)
            exit(1)
        }
        do {
            try events
                .filter { $0.flag.contains([.itemCreated, .itemIsFile]) }
                .forEach { event in
                    print("🍵 Appended files \(event.path) 🍵")
                    xcodeproject.appendFile(path: event.path, targetName: targetName)
                    try xcodeproject.write()
            }
        } catch {
            print(error.localizedDescription)
            exit(1)
        }
    }
    RunLoop.current.run()
    }
    .run()

