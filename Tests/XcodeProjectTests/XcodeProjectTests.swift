import XCTest
@testable import XcodeProject

func isDirectory(_ dirName: String) -> Bool {
    let fileManager = FileManager.default
    var isDir: ObjCBool = false
    if fileManager.fileExists(atPath: dirName, isDirectory: &isDir) {
        if isDir.boolValue {
            return true
        }
    }
    return false
}


class XcodeProjectTests: XCTestCase {
    func testAppendFilePathToTargetName() {
        XCTContext.runActivity(named: "When append file is not exist", block: { _ in
            XCTContext.runActivity(named: "and directory is not exists", block: { (_) in
                XCTContext.runActivity(named: "when under the Hoge/. Hoge is not exists", block: { _ in
                    let xcodeproject = makeXcodeProject()
                    let originalObjects = xcodeproject.context.objects
                    
                    from: do {
                        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                    
                    xcodeproject.append(filePath: "Hoge/aaaa.swift", to: xcodeProjectUrl().absoluteString, targetName: "iOSTestProject")
                    
                    to: do {
                        XCTAssertEqual(originalObjects.keys.count + 3, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                })
                XCTContext.runActivity(named: "when under the Hoge/Fuga. Hoge and Fuga is not exists", block: { _ in
                    let xcodeproject = makeXcodeProject()
                    let originalObjects = xcodeproject.context.objects
                    
                    from: do {
                        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                    
                    xcodeproject.append(filePath: "Hoge/Fuga/aaaa.swift", to: xcodeProjectUrl().absoluteString, targetName: "iOSTestProject")
                    
                    to: do {
                        XCTAssertEqual(originalObjects.keys.count + 4, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count + 2, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                })
            })
            XCTContext.runActivity(named: "and directory is exists", block: { (_) in
                XCTContext.runActivity(named: "when root directory", block: { _ in
                    let xcodeproject = makeXcodeProject()
                    let originalObjects = xcodeproject.context.objects
                    
                    from: do {
                        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                    
                    xcodeproject.append(filePath: "aaaa.swift", to: xcodeProjectUrl().absoluteString, targetName: "iOSTestProject")
                    
                    to: do {
                        XCTAssertEqual(originalObjects.keys.count + 2, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                })
                XCTContext.runActivity(named: "when under the iOSTestProject/", block: { _ in
                    let xcodeproject = makeXcodeProject()
                    let originalObjects = xcodeproject.context.objects
                    
                    from: do {
                        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                    
                    xcodeproject.append(filePath: "iOSTestProject/aaaa.swift", to: xcodeProjectUrl().absoluteString, targetName: "iOSTestProject")
                    
                    to: do {
                        XCTAssertEqual(originalObjects.keys.count + 2, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                })
                XCTContext.runActivity(named: "when under the iOSTestProject/Group", block: { _ in
                    let xcodeproject = makeXcodeProject()
                    let originalObjects = xcodeproject.context.objects
                    
                    from: do {
                        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                    
                    xcodeproject.append(filePath: "iOSTestProject/Group/aaaa.swift", to: xcodeProjectUrl().absoluteString, targetName: "iOSTestProject")
                    
                    to: do {
                        XCTAssertEqual(originalObjects.keys.count + 2, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                })
            })
        })
        
        XCTContext.runActivity(named: "When append file is exist", block: { _ in
            XCTContext.runActivity(named: "and directory is exists", block: { _ in
                XCTContext.runActivity(named: "when root directory", block: { _ in
                    let xcodeproject = makeXcodeProject()
                    let originalObjects = xcodeproject.context.objects
                    
                    from: do {
                        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                    
                    xcodeproject.append(filePath: "Config.swift", to: xcodeProjectUrl().absoluteString, targetName: "iOSTestProject")
                    
                    to: do {
                        // TODO: Fix for build file count
//                        XCTAssertEqual(originalObjects.keys.count + 1, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
//                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                })
                XCTContext.runActivity(named: "when under the iOSTestProject/", block: { _ in
                    let xcodeproject = makeXcodeProject()
                    let originalObjects = xcodeproject.context.objects
                    
                    from: do {
                        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                    
                    xcodeproject.append(filePath: "iOSTestProject/AppDelegate.swift", to: xcodeProjectUrl().absoluteString, targetName: "iOSTestProject")
                    
                    to: do {
                        // TODO: Fix for build file count
//                        XCTAssertEqual(originalObjects.keys.count + 2, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
//                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                })
                XCTContext.runActivity(named: "when under the iOSTestProject/Group", block: { _ in
                    let xcodeproject = makeXcodeProject()
                    let originalObjects = xcodeproject.context.objects
                    
                    from: do {
                        // TODO: Fix for build file count
                        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                    
                    xcodeproject.append(filePath: "iOSTestProject/Group/FileReference.swift", to: xcodeProjectUrl().absoluteString, targetName: "iOSTestProject")
                    
                    to: do {
//                        XCTAssertEqual(originalObjects.keys.count + 2, xcodeproject.context.objects.keys.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
//                        XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
                    }
                })
            })
        })
        
    }
}
