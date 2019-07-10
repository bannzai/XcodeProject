//
//  PBXProjectParserTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import XCTest
@testable import XcodeProject

class PBXProjectParserTests: XCTestCase {
    func testParse() {
        do {
            let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
            XCTAssert(parser.context().dictionary.count == 58)
            XCTAssert(parser.context().fullFilePaths.count == 15)
            XCTAssert(parser.context().grouped.count == 13)
            XCTAssert(parser.pair().count == 5)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
