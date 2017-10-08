import XCTest
@testable import XcodeProject

class GeneratorTests: XCTestCase {
    func testWrite() {
        guard
            let testPath = ProcessInfo().environment["PBXProjectPath"],
            let url = URL(string: "file://" + testPath)
            else {
                XCTFail("Should set environment PBXProjectPath.")
                return
        }
        
        let string = try! String(contentsOf: url, encoding: String.Encoding.utf8)
        let project = try! XCProject(for: url)
        let serialization = XCPSerialization(project: project)
        let generateString = try! serialization.generateWriteContent()
        
        if string != generateString {
            XCTFail("unexception should same read and write content")
            
        }
    }
    
    static var allTests = [
        ("testExample", testWrite),
    ]
}
