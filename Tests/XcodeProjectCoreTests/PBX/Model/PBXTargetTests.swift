//
//  PBXTargetTests.swift
//  XcodeProjectCore
//
//  Created by Yudai Hirose on 2019/07/26.
//

import XCTest
@testable import XcodeProjectCore

class PBXTargetTests: XCTestCase {
    func testAppendFile() {
        let project = makeXcodeProject()
        let target = project.targets[name: "iOSTestProject"]!
        let originalBuildPhases = target.buildPhases
        let subjectForBuildPhases: ([PBX.BuildPhase]) -> Int = {
            $0.compactMap { $0 as? PBX.SourcesBuildPhase }.count
        }
        from: do {
            XCTAssertEqual(originalBuildPhases.count, target.buildPhases.count)
            XCTAssertEqual(subjectForBuildPhases(originalBuildPhases), subjectForBuildPhases(project.targets[name: "iOSTestProject"]!.buildPhases))
        }

        project.groups.first?.appendFile(name: "aaa.swift")
        target.appendSourceBuildFile(fileName: "aaa.swift")
        
        to: do {
            XCTAssertEqual(originalBuildPhases.count + 1, target.buildPhases.count)
            XCTAssertEqual(subjectForBuildPhases(originalBuildPhases) + 1, subjectForBuildPhases(project.targets[name: "iOSTestProject"]!.buildPhases))
        }
    }
}
