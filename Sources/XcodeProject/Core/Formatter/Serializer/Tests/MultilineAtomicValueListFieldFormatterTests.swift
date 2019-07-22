//
//  MultilineAtomicValueListFieldFormatterTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/22.
//

import XCTest
@testable import XcodeProject

class MultilineAtomicValueListFieldFormatterTests: XCTestCase {
    func make() -> AtomicValueListFieldFormatter.Component.Multipleline {
        return AtomicValueListFieldFormatter
            .Component
            .Multipleline(
                project: makeXcodeProject()
        )
    }

    func tesFormat() {
        XCTContext.runActivity(named: "When empty object ids", block: { _ in
            let formatter = make()
//            formatter.format(of: <#T##(key: String, objectIds: [PBXObjectIDType])#>, level: <#T##Int#>)
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
