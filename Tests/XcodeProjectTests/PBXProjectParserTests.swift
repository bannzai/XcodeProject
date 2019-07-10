//
//  PBXProjectParserTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import XCTest
@testable import XcodeProject

class PBXProjectParserTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
