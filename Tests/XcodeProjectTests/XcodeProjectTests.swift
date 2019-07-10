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
    
}
