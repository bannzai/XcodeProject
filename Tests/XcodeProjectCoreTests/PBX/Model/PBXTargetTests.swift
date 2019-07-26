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
        XCTContext.runActivity(named: "When source code fie", block: { _ in
            let project = makeXcodeProject()
            let target = project.targets[name: "iOSTestProject"]!
            let originalBuildPhases = target.buildPhases
            let subjectForBuildFile: ([PBX.BuildPhase]) -> Int = {
                $0.compactMap { $0 as? PBX.SourcesBuildPhase }.first?.files.count ?? 0
            }
            let subjectForBuldPhase: ([PBX.BuildPhase]) -> Int = {
                $0.compactMap { $0 as? PBX.SourcesBuildPhase }.count
            }
            let originalCount = subjectForBuildFile(originalBuildPhases)
            from: do {
                XCTAssertEqual(subjectForBuldPhase(originalBuildPhases), subjectForBuldPhase(target.buildPhases))
                XCTAssertEqual(originalCount, subjectForBuildFile(target.buildPhases))
            }
            
            project.groups.first?.appendFile(name: "aaa.swift")
            target.appendToSourceBuildFile(fileName: "aaa.swift")
            
            to: do {
                XCTAssertEqual(subjectForBuldPhase(originalBuildPhases), subjectForBuldPhase(target.buildPhases))
                XCTAssertEqual(originalCount + 1, subjectForBuildFile(target.buildPhases))
            }
        })
        
        XCTContext.runActivity(named: "When resource code fie", block: { _ in
            let project = makeXcodeProject()
            let target = project.targets[name: "iOSTestProject"]!
            let originalBuildPhases = target.buildPhases
            let subjectForBuildFile: ([PBX.BuildPhase]) -> Int = {
                $0.compactMap { $0 as? PBX.ResourcesBuildPhase }.first?.files.count ?? 0
            }
            let subjectForBuldPhase: ([PBX.BuildPhase]) -> Int = {
                $0.compactMap { $0 as? PBX.ResourcesBuildPhase }.count
            }
            let originalCount = subjectForBuildFile(originalBuildPhases)
            from: do {
                XCTAssertEqual(subjectForBuldPhase(originalBuildPhases), subjectForBuldPhase(target.buildPhases))
                XCTAssertEqual(originalCount, subjectForBuildFile(target.buildPhases))
            }
            
            project.groups.first?.appendFile(name: "aaa.xib")
            target.appendToResourceBuildFile(fileName: "aaa.xib")
            
            to: do {
                XCTAssertEqual(subjectForBuldPhase(originalBuildPhases), subjectForBuldPhase(target.buildPhases))
                XCTAssertEqual(originalCount + 1, subjectForBuildFile(target.buildPhases))
            }
        })
    }
}
