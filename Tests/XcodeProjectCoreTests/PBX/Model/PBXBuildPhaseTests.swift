//
//  PBXBuildFileTests.swift
//  XcodeProjectCoreTests
//
//  Created by Yudai Hirose on 2019/07/26.
//

import XCTest
@testable import XcodeProjectCore

class PBXBuildPhaseTests: XCTestCase {
    func testAppendFile() {
        XCTContext.runActivity(named: "When source code fie", block: { _ in
            let project = makeXcodeProject()
            let buildPhase = project.buildPhases.first!
            let originalFilesCount = buildPhase.files.count

            from: do {
                XCTAssertEqual(originalFilesCount, buildPhase.files.count)
            }
            
            project.groups.first?.appendFile(name: "aaa.swift")
            buildPhase.appendFile(fileName: "aaa.swift")
            
            to: do {
                XCTAssertEqual(originalFilesCount + 1, buildPhase.files.count)
            }
        })
    }
}
