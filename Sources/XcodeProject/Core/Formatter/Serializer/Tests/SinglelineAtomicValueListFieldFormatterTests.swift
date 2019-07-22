//
//  SinglelineAtomicValueListFieldFormatterTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/22.
//

import XCTest
@testable import XcodeProject

class SinglelineAtomicValueListFieldFormatterTests: XCTestCase {

    func make() -> AtomicValueListFieldFormatter.Component.Singleline {
        return AtomicValueListFieldFormatter
            .Component
            .Singleline(
                project: makeXcodeProject()
        )
    }
    
    func testFormat() {
        XCTContext.runActivity(named: "When empty object ids", block: { _ in
            let formatter = make()
            let got = formatter.format(of: (key: "ATTRIBUTES", objectIds: ["CodeSignOnCopy", "RemoveHeadersOnCopy"]), level: 0)
            XCTAssertEqual(
                got,
                "ATTRIBUTES = (CodeSignOnCopy, RemoveHeadersOnCopy, ); "
            )
        })
        XCTContext.runActivity(named: "When empty object ids", block: { _ in
            // NOTE: Unexpected pattern
        })
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
