//
//  SinglelinePBXAtomicValueListFieldFormatterTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/22.
//

import XCTest
@testable import XcodeProject

class SinglelinePBXAtomicValueListFieldFormatterTests: XCTestCase {

    func make() -> SinglelinePBXAtomicValueListFieldFormatter {
        return SinglelinePBXAtomicValueListFieldFormatter()
    }
    
    func testFormat() {
        XCTContext.runActivity(named: "When empty object ids", block: { _ in
            let project = makeXcodeProject()
            let formatter = make()
            let got = formatter.format(context: project.context, of: (key: "ATTRIBUTES", objectIds: ["CodeSignOnCopy", "RemoveHeadersOnCopy"]), level: 0)
            XCTAssertEqual(
                got,
                "ATTRIBUTES = (CodeSignOnCopy, RemoveHeadersOnCopy, ); "
            )
        })
        XCTContext.runActivity(named: "When empty object ids", block: { _ in
            // NOTE: Unexpected pattern
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
