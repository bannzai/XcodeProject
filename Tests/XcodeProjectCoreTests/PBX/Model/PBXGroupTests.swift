//
//  PBX.swift
//  XcodeProjectCoreTests
//
//  Created by Yudai Hirose on 2019/07/26.
//

import XCTest
@testable import XcodeProjectCore

class PBXGroupTests: XCTestCase {
    func testAppendFile() {
        let project = makeXcodeProject()
        let group = project.groups.first!
        let originalChildren = group.children
        from: do {
            XCTAssertEqual(originalChildren.count, group.children.count)
            XCTAssertNil(project.context.fileRefs[path: "aaaa.swift"])
        }
        group.appendFile(name: "aaaa.swift")
        to: do {
            XCTAssertEqual(originalChildren.count + 1, group.children.count)
            XCTAssertNotNil(project.context.fileRefs[path: "aaaa.swift"])
        }
    }
    
    func testRemoveFile() {
        let project = makeXcodeProject()
        let group = project.groups[path: "iOSTestProject"]!
        let originalChildren = group.children
        from: do {
            XCTAssertEqual(originalChildren.count, group.children.count)
            XCTAssertNotNil(project.context.fileRefs[path: "AppDelegate.swift"])
        }
        
        group.removeFile(fileName: "AppDelegate.swift")
        
        to: do {
            XCTAssertEqual(originalChildren.count - 1, group.children.count)
            XCTAssertNil(project.context.fileRefs[path: "AppDelegate.swift"])
        }
    }
}
