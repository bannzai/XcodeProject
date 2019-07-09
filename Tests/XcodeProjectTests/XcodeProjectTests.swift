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

extension Context {
    var grouped: [String: [PBX.Object]] {
        return self.dictionary
            .values
            .toArray()
            .groupBy { $0.isa.rawValue }
    }
}

extension XcodeProjectTests {
    func testRead() {
        do {
            let project = XcodeProject(
                parser: try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl),
                hashIDGenerator: PBXObjectHashIDGenerator()
            )
            XCTAssert(project.allPBX.dictionary.count == 56)
            XCTAssert(project.allPBX.fullFilePaths.count == 13)
            XCTAssert(project.allPBX.grouped.count == 13)
            XCTAssert(project.fullPair.count == 5)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testReadToWriteEqualToSameContent() {
        do {
            let originalContent = try String(contentsOf: xcodeProjectUrl, encoding: String.Encoding.utf8)
            
            let project = XcodeProject(
                parser: try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl),
                hashIDGenerator: PBXObjectHashIDGenerator()
            )
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
