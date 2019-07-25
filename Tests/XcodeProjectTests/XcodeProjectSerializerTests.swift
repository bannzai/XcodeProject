//
//  XcodeProjectSerializerTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import XCTest
@testable import XcodeProject
import Swdifft

class XcodeProjectSerializerTests: XCTestCase {
    func make() -> XcodeProjectSerializer {
        return XcodeProjectSerializer()
    }
    
    func testSerialize() {
        do {
            let project = makeXcodeProject()
            let originalContent = try String(contentsOf: xcodeProjectUrl(), encoding: String.Encoding.utf8)
            let serialization = make()
            let generateString = serialization.serialize(project: project)
            
            print(generateString)
            print(originalContent)
            XCTAssertEqual(originalContent, generateString)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
