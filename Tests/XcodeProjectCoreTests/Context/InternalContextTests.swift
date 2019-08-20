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
            XCTAssertTrue(context.groups[fullPath: "iOSTestProject"]!.fileRefs[0].fullPath.contains("iOSTestProject"))
        }
        XCTContext.runActivity(named: "Check set full path when called resetGroupFullPaths") { (_) in
            let xcodeproject = makeXcodeProject()
            let context = xcodeproject.context
            

            XCTAssertNotNil(context.groups[fullPath: "iOSTestProject"])
            XCTAssertFalse(context.groups[fullPath: "iOSTestProject"]!.fileRefs.isEmpty)
            context.groups[fullPath: "iOSTestProject"]?.fileRefs.forEach {
                XCTAssertTrue($0.fullPath.contains("iOSTestProject"))
            }

            context.groups[fullPath: "iOSTestProject"]?.path = nil
            context.groups[fullPath: "iOSTestProject"]?.name = "iOSTestProject"
            context.resetGroupFullPaths()
            
            XCTAssertNil(context.groups[fullPath: "iOSTestProject"])

            context.groups[fullPath: "iOSTestProject"]?.path = "iOSTestProject"
            context.groups[fullPath: "iOSTestProject"]?.name = nil
            context.resetGroupFullPaths()
            
            XCTAssertNotNil(context.groups[fullPath: "iOSTestProject"])
            XCTAssertFalse(context.groups[fullPath: "iOSTestProject"]!.fileRefs.isEmpty)
            context.groups[fullPath: "iOSTestProject"]?.fileRefs.forEach {
                XCTAssertTrue($0.fullPath.contains("iOSTestProject"))
            }
            
        }
    }

}
