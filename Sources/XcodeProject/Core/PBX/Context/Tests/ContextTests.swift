//
//  ContextTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/23.
//

import XCTest
@testable import XcodeProject

class ContextTests: XCTestCase {
    func make() -> InternalContext {
        return try! PBXProjectContextParser().parse(xcodeprojectUrl: xcodeProjectUrl()) as! InternalContext
    }
    
    func testCreateGroupPath() {
        let context = make()
        let project = context.extractPBXProject()
        context.createGroupPath(with: project.mainGroup, parentPath: "")
    }

}
