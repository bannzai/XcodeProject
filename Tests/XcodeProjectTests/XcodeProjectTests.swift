import XCTest
@testable import XcodeProject

class XcodeProjectTests: XCTestCase {

    func testShouldCacheContext() {
        do {
            let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
            let context1 = parser.context()
            let context2 = parser.context()
            XCTAssert(context1 === context2)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSerialize() {
        do {
            let originalContent = try String(contentsOf: xcodeProjectUrl(), encoding: String.Encoding.utf8)
            
            let project = XcodeProject(
                parser: try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl()),
                hashIDGenerator: PBXObjectHashIDGenerator()
            )
            let serialization = XcodeProjectSerializer(project: project)
            let generateString = try serialization.serialize()
            
            if originalContent != generateString {
                XCTFail("unexception should same read and write content")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
