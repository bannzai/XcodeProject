//
//  BuildPhaseAppenderTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/24.
//

import XCTest
@testable import XcodeProject

class BuildPhaseAppenderTests: XCTestCase {
    
    func make() -> BuildPhaseAppender {
        return BuildPhaseAppenderImpl(
            hashIDGenerator: PBXObjectHashIDGenerator(),
            resourceBuildPhaseAppender: ResourceBuildPhaseAppenderImpl(hashIDGenerator: PBXObjectHashIDGenerator()),
            sourceBuildPhaseAppender: SourceBuildPhaseAppenderImpl(hashIDGenerator: PBXObjectHashIDGenerator())
        )
    }
    
    func testAppend() {
        XCTContext.runActivity(named: "When append file is not exist", block: { _ in
            let xcodeproject = makeXcodeProject()
            let appender = make()
            let originalObjects = xcodeproject.context.objects
            
            let fileRef = FileRefExtractorImpl(groupExtractor: GroupExtractorImpl()).extract(context: xcodeproject.context, groupPath: "iOSTestProject", fileName: "AppDelegate.swift")!
            
            XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.SourcesBuildPhase }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.SourcesBuildPhase }.count)
            appender.append(context: xcodeproject.context, fileRefID: fileRef.id, targetName: "iOSTestProject", fileName: fileRef.path!)
            XCTAssertNotEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
            XCTAssertNotEqual(originalObjects.values.compactMap { $0 as? PBX.SourcesBuildPhase }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.SourcesBuildPhase }.count)
        })
        
        XCTContext.runActivity(named: "When append file is exist", block: { _ in
            let xcodeproject = makeXcodeProject()
            let appender = make()
            let originalObjects = xcodeproject.context.objects
            
            let fileRef = FileRefExtractorImpl(groupExtractor: GroupExtractorImpl()).extract(context: xcodeproject.context, groupPath: "iOSTestProject", fileName: "AppDelegate.swift")!
            
            XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.SourcesBuildPhase }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.SourcesBuildPhase }.count)
            appender.append(context: xcodeproject.context, fileRefID: fileRef.id, targetName: "iOSTestProject", fileName: fileRef.path!)
            XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.SourcesBuildPhase }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.SourcesBuildPhase }.count)
        })
    }
}
