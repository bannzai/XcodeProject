//
//  XcodeProjectSerializerTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import XCTest
@testable import XcodeProject

class XcodeProjectSerializerTests: XCTestCase {
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
