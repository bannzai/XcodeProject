//
//  XcodeProjectPropertiesTests.swift
//  XcodeProjectCoreTests
//
//  Created by Yudai Hirose on 2019/08/21.
//

import XCTest
@testable import XcodeProjectCore

class XcodeProjectPropertiesTests: XCTestCase {

    func testVariantGroup() {
        let xcodeproject = makeXcodeProject()
        XCTAssertFalse(xcodeproject.context.fileRefs.filter { $0.parentGroup is PBX.VariantGroup }.isEmpty)
    }

}
