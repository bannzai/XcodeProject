import XCTest
@testable import XcodeProject

class XcodeProjectTests: XCTestCase {
    static var allTests = [
        ("testReadToWriteEqualToSameContent", testReadToWriteEqualToSameContent),
    ]
    
    private var xcodeProjectUrl: URL {
        guard
            let testPath = ProcessInfo().environment["PBXProjectPath"],
            let url = URL(string: "file://" + testPath)
            else {
                XCTFail("Should set environment PBXProjectPath.")
                fatalError()
        }
        
        return url
    }
}

extension XcodeProjectTests {
    func testRead() {
        do {
            let project = try XcodeProject(for: xcodeProjectUrl)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testReadToWriteEqualToSameContent() {
        do {
            let originalContent = try String(contentsOf: xcodeProjectUrl, encoding: String.Encoding.utf8)
            
            let project = try XcodeProject(for: xcodeProjectUrl)
            let serialization = XcodeSerialization(project: project)
            let generateString = try serialization.generateWriteContent()
            
            if originalContent != generateString {
                XCTFail("unexception should same read and write content")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
