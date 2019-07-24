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
        return makeSerializer()
    }
    
    func testSerialize() {
        do {
            let originalContent = try String(contentsOf: xcodeProjectUrl(), encoding: String.Encoding.utf8)
            let serialization = make()
            let generateString = serialization.serialize()
            
            print(generateString)
            print(originalContent)
            XCTAssertEqual(originalContent, generateString)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
