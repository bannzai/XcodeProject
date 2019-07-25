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
        let subjectForFiles: ([PBX.BuildPhase]) -> Int = {
            $0.compactMap { $0 as? PBX.SourcesBuildPhase }.first!.files.count
        }
        from: do {
            XCTAssertEqual(originalBuildPhases.count, target.buildPhases.count)
            XCTAssertEqual(subjectForFiles(originalBuildPhases), subjectForFiles(target.buildPhases))
        }

        project.groups.first?.appendFile(name: "aaa.swift")
        target.appendSourceBuildFile(fileName: "aaa.swift")
        
        to: do {
            XCTAssertEqual(originalBuildPhases.count + 1, target.buildPhases.count)
            XCTAssertEqual(subjectForFiles(originalBuildPhases) + 1, subjectForFiles(target.buildPhases))
        }
    }
}
