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
    
    func testAppendFieeRef() {
        let xcodeproject = makeXcodeProject()
        let originalObjects = xcodeproject.context.objects
        
        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
        XCTAssertEqual(originalObjects.values.count, xcodeproject.context.objects.values.count)
        xcodeproject.appendFileRef("aaaa.swift", and: "ABCDEFG")
        XCTAssertNotEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
        XCTAssertNotEqual(originalObjects.values.count, xcodeproject.context.objects.values.count)
    }
    
    func testIsExistsGroupPath() {
        XCTContext.runActivity(named: "When is exists group", block:  { _ in
            XCTContext.runActivity(named: "It is flatten", block: { _ in
                let xcodeproject = makeXcodeProject()
                XCTAssertTrue(
                    xcodeproject.isExistsGroupPath(path: "iOSTestProject")
                )
            })
            XCTContext.runActivity(named: "It is nested", block: { _ in
                let xcodeproject = makeXcodeProject()
                XCTAssertTrue(
                    xcodeproject.isExistsGroupPath(path: "iOSTestProject/Group")
                )
            })
        })
        XCTContext.runActivity(named: "When is not exists group", block:  { _ in
            let xcodeproject = makeXcodeProject()
            XCTAssertFalse(
                xcodeproject.isExistsGroupPath(path: "Hoge")
            )
        })
    }
    
    func testGroup() {
        let xcodeproject = makeXcodeProject()
        
        XCTContext.runActivity(named: "./") { (_) in
            let groupEachPaths = xcodeproject.makeGroupEachPaths(for: "./")
            let result = xcodeproject.existsGroup(groupEachPaths: groupEachPaths, groupPathNames: ["Domain", "Model"])
            XCTAssertTrue(result == nil)
        }
        
        XCTContext.runActivity(named: projectRootPath().absoluteString) { (_) in
            print(projectRootPath().absoluteString)
            print(isDirectory(projectRootPath().absoluteString))
            let groupEachPaths = xcodeproject.makeGroupEachPaths(for: projectRootPath().absoluteString)
            let result = xcodeproject.existsGroup(groupEachPaths: groupEachPaths, groupPathNames: ["iOSTestProject"])
            XCTAssertTrue(result == nil)
        }
        
    }

}
