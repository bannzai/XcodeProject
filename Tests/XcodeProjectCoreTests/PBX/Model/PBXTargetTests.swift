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
        XCTContext.runActivity(named: "When add source code file", block: { _ in
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
                XCTAssertNil(project.context.buildPhases[fileName: "aaa.swift"])
            }
            
            project.groups.first?.appendFile(name: "aaa.swift")
            target.appendToSourceBuildFile(fileName: "aaa.swift")
            
            to: do {
                XCTAssertEqual(subjectForBuldPhase(originalBuildPhases), subjectForBuldPhase(target.buildPhases))
                XCTAssertEqual(originalCount + 1, subjectForBuildFile(target.buildPhases))
                XCTAssertNotNil(project.context.buildPhases[fileName: "aaa.swift"])
            }
        })
        
        XCTContext.runActivity(named: "When add resource code file", block: { _ in
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
                XCTAssertNil(project.context.buildPhases[fileName: "aaa.xib"])
            }
            
            project.groups.first?.appendFile(name: "aaa.xib")
            target.appendToResourceBuildFile(fileName: "aaa.xib")
            
            to: do {
                XCTAssertEqual(subjectForBuldPhase(originalBuildPhases), subjectForBuldPhase(target.buildPhases))
                XCTAssertEqual(originalCount + 1, subjectForBuildFile(target.buildPhases))
                XCTAssertNotNil(project.context.buildPhases[fileName: "aaa.xib"])
            }
        })
        
        XCTContext.runActivity(named: "When remove source code file ", block: { _ in
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
                XCTAssertNotNil(project.context.buildPhases[fileName: "AppDelegate.swift"])
            }
            
            target.removeToSourceBuildFile(fileName: "AppDelegate.swift")

            to: do {
                XCTAssertEqual(subjectForBuldPhase(originalBuildPhases), subjectForBuldPhase(target.buildPhases))
                XCTAssertEqual(originalCount - 1, subjectForBuildFile(target.buildPhases))
                XCTAssertNil(project.context.buildPhases[fileName: "AppDelegate.swift"])
            }
        })
        
        XCTContext.runActivity(named: "When remove resource code file ", block: { _ in
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
                XCTAssertNotNil(project.context.buildPhases[fileName: "TableViewCell.xib"])
            }
            
            target.removeToResourceBuildFile(fileName: "TableViewCell.xib")
            
            to: do {
                XCTAssertEqual(subjectForBuldPhase(originalBuildPhases), subjectForBuldPhase(target.buildPhases))
                XCTAssertEqual(originalCount - 1, subjectForBuildFile(target.buildPhases))
                XCTAssertNil(project.context.buildPhases[fileName: "TableViewCell.xib"])
            }
        })
    }
}
