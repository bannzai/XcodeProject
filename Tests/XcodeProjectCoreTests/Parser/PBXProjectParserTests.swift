//
//  PBXProjectContextParserTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import XCTest
@testable import XcodeProjectCore

class PBXProjectContextParserTests: XCTestCase {
    func testParse() {
        do {
            _ = try PBXProjectContextParser().parse(xcodeprojectUrl: xcodeProjectUrl())
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
