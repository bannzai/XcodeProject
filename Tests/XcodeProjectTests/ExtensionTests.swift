import XCTest
@testable import XcodeProject

class ArrayExtensionTests: XCTestCase {
    func testOfType() {
        let array: [Any] = [1, 2, 3, "test"]
        let converted = array.ofType(Int.self)
        XCTAssert(converted.count == 3)
    }
    
    func testGroupBy() {
        struct PBXTest {
            let isa: String
            let testId: Int
        }
        let array = [
            PBXTest(isa: "PBXObject", testId: 1),
            PBXTest(isa: "PBXObject", testId: 2),
            PBXTest(isa: "PBXObject", testId: 3),
            PBXTest(isa: "PBXObject", testId: 4),
            PBXTest(isa: "PBXBuildFile", testId: 1),
        ]
        let groupedDictionary = array
            .groupBy { (object) -> String in
                return object.isa
        }
        
        XCTAssert(groupedDictionary.keys.count == 2, "Grouped key type is PBXObject, PBXBuildFile")
        XCTAssert(groupedDictionary["PBXObject"]?.count == 4)
        XCTAssert(groupedDictionary["PBXBuildFile"]?.count == 1)
    }
    
    static var allTests = [
        ("testOfType", testOfType),
        ("testGroupBy", testGroupBy),
        ]
}

