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
        let r = makeParserAndSerializer()
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
    
    func testEscapeWithTarget() {
        XCTContext.runActivity(named: "A", block: { _ in
            do {
                let (_, serialization) = make()
                
                let input = "\"# Type a script or drag a script file from your workspace to insert its path.\necho \"Script\"\n\""
                let expected = "\"\\\"# Type a script or drag a script file from your workspace to insert its path.\\necho \\\"Script\\\"\\n\\\"\""
                let got = try serialization.escape(with: input)
                
                XCTAssertEqual(got, expected, formatDiff(got, expected))
            } catch {
                XCTFail(error.localizedDescription)
            }
        })
    }
}
