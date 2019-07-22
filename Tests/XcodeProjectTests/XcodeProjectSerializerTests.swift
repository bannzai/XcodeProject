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
    func make() -> (Context, XcodeProjectSerializer) {
        let r = makeContextParserAndSerializer()
        return (r.0.context(), r.1)
    }
    
    func testSerialize() {
        do {
            let originalContent = try String(contentsOf: xcodeProjectUrl(), encoding: String.Encoding.utf8)
            let (_, serialization) = make()
            let generateString = serialization.serialize()
            
            print(generateString)
            print(originalContent)
            XCTAssertEqual(originalContent, generateString)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
