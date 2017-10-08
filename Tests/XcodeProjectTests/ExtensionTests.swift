import XCTest
@testable import XcodeProject

class StringExtensionTests: XCTestCase {
    func testMatchFirst() {
        XCTAssertEqual(XcodeProject().text, "Hello, World!")
    }
    
    
    static var allTests = [
        ("testExample", testExample),
        ]
}

