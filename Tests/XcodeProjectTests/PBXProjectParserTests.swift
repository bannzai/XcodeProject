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
            let parser1 = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
            let parser2 = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
            XCTAssertEqual(parser1.context().dictionary.count, parser2.context().dictionary.count)
            XCTAssertEqual(parser1.context().fullFilePaths.count, parser2.context().fullFilePaths.count)
            XCTAssertEqual(parser1.context().grouped.count, parser2.context().grouped.count)
            XCTAssertEqual(parser1.pair().count, parser2.pair().count)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testShouldCacheContext() {
        do {
            let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
            let context1 = parser.context()
            let context2 = parser.context()
            XCTAssert(context1 === context2)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
