//
//  InternalContextTests.swift
//  XcodeProjectCoreTests
//
//  Created by Yudai Hirose on 2019/08/19.
//

import XCTest
@testable import XcodeProjectCore

class InternalContextTests: XCTestCase {

    func testResetGroupFullPaths() {
        XCTContext.runActivity(named: "Check set full path for iOSTestProject PBXGroup") { (_) in
            let xcodeproject = makeXcodeProject()
            let context = xcodeproject.context
            let subject = {
                return context.groups.filter { $0.pathOrNameOrEmpty == "iOSTestProject" }.last!
            }
            XCTAssertTrue(subject().fileRefs[0].fullPath.contains("iOSTestProject"))
        }
        XCTContext.runActivity(named: "Check set full path when called resetGroupFullPaths") { (_) in
            let xcodeproject = makeXcodeProject()
            let context = xcodeproject.context
            
            
            let subject = {
                return context.groups.filter { $0.pathOrNameOrEmpty == "iOSTestProject" }.last!
            }

            XCTAssertNotNil(context.groups[fullPath: "iOSTestProject"])
            subject().fileRefs.forEach {
                XCTAssertTrue($0.fullPath.contains("iOSTestProject"))
            }

            subject().name = "iOSTestProject"
            subject().path = nil
            context.resetGroupFullPaths()
            
            XCTAssertNil(context.groups[fullPath: "iOSTestProject"])
            subject().fileRefs.forEach {
                XCTAssertFalse($0.fullPath.contains("iOSTestProject"))
            }

            subject().path = "iOSTestProject"
            subject().name = nil
            context.resetGroupFullPaths()
            
            XCTAssertNotNil(context.groups[fullPath: "iOSTestProject"])
            subject().fileRefs.forEach {
                XCTAssertTrue($0.fullPath.contains("iOSTestProject"))
            }
            
        }
    }

}
