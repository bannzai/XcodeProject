//
//  MultilinePBXAtomicValueListFieldFormatterTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/22.
//

import XCTest
@testable import XcodeProjectCore

class MultilinePBXAtomicValueListFieldFormatterTests: XCTestCase {
    func make() -> MultiplelinePBXAtomicValueListFieldFormatter {
        return MultiplelinePBXAtomicValueListFieldFormatter()
    }
    
    func testFormat() {
        XCTContext.runActivity(named: "When empty object ids", block: { _ in
            let project = makeXcodeProject()
            let formatter = make()
            let got = formatter.format(context: project.context, of: (key: "files", objectIds: []), level: 0)
            XCTAssertEqual(
                got,
                """
                files = (
                );
                """
            )
        })
        XCTContext.runActivity(named: "When empty object ids", block: { _ in
            let project = makeXcodeProject()
            let formatter = make()
            let got = formatter.format(context: project.context, of: (key: "files", objectIds: ["BA42680E1F89EB7F001FA700", "BA42680B1F89EB7F001FA700", "BA4268091F89EB7F001FA700"]), level: 0)
            XCTAssertEqual(
                got,
                """
                files = (
                \(indent)BA42680E1F89EB7F001FA700 /* LaunchScreen.storyboard in Resources */,
                \(indent)BA42680B1F89EB7F001FA700 /* Assets.xcassets in Resources */,
                \(indent)BA4268091F89EB7F001FA700 /* Main.storyboard in Resources */,
                );
                """
            )
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
