import XCTest
@testable import XcodeProject

class XcodeProjectTests: XCTestCase {
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
    func testParse() {
        do {
            let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl)
            XCTAssert(parser.context().dictionary.count == 58)
            XCTAssert(parser.context().fullFilePaths.count == 15)
            XCTAssert(parser.context().grouped.count == 13)
            XCTAssert(parser.pair().count == 5)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testShouldCacheContext() {
        do {
            let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl)
            let context1 = parser.context()
            let context2 = parser.context()
            XCTAssert(context1 === context2)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSerialize() {
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
