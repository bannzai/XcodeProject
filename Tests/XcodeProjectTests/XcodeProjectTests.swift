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
    
}
