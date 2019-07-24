//
//  PBXProjectContextParserTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import XCTest
@testable import XcodeProject

class PBXProjectContextParserTests: XCTestCase {
    func testParse() {
        do {
            let context = try PBXProjectContextParser().parse(xcodeprojectUrl: xcodeProjectUrl())
//            XCTAssert(parser.context().dictionary.count == 58)
//            XCTAssert(parser.context().fullFilePaths.count == 15)
//            XCTAssert(parser.context().grouped.count == 13)
            XCTAssert(context.allPBX.count == 5)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
