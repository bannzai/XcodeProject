import XCTest
@testable import XcodeProject

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

    func testAppendGroup() {
        let xcodeproject = makeXcodeProject()
        let originalObjects = xcodeproject.context.objects
        
        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
        XCTAssertEqual(originalObjects.values.count, xcodeproject.context.objects.values.count)
        xcodeproject.appendGroupIfNeeded(with: [(PBX.Group.init(id: <#T##String#>, dictionary: <#T##PBXRawMapType#>, isa: <#T##String#>, context: <#T##Context#>), String)], childId: <#T##String#>, groupPathNames: <#T##[String]#>)
        XCTAssertNotEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
        XCTAssertNotEqual(originalObjects.values.count, xcodeproject.context.objects.values.count)
    }
}
