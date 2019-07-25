//
//  BuildPhaseAppenderTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/24.
//

import XCTest
@testable import XcodeProject

class BuildFileAppenderTests: XCTestCase {
    
    func make() -> BuildFileAppender {
        return BuildFileAppenderImpl(
            hashIDGenerator: PBXObjectHashIDGenerator(),
            resourceBuildPhaseAppender: ResourceBuildPhaseAppenderImpl(hashIDGenerator: PBXObjectHashIDGenerator()),
            sourceBuildPhaseAppender: SourceBuildPhaseAppenderImpl(hashIDGenerator: PBXObjectHashIDGenerator())
        )
    }
    
    func testAppend() {
        XCTContext.runActivity(named: "When append file is not exist", block: { _ in
            let xcodeproject = makeXcodeProject()
            let appender = make()

            let mockIDGenerator = StringGeneratorMock()
            mockIDGenerator.generateReturnValue = "ABC"
            let maker = FileReferenceMakerImpl(hashIDGenerator: mockIDGenerator)
            let fileRef = FileReferenceAppenderImpl(fileReferenceMaker: maker)
                .append(context: xcodeproject.context, filePath: "iOSTestProject/Hoge.swift")
            
            let originalObjects = xcodeproject.context.objects
            
            XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
            appender.append(context: xcodeproject.context, fileRefID: fileRef.id, targetName: "iOSTestProject", fileName: fileRef.path!)
            XCTAssertEqual(originalObjects.keys.count + 1, xcodeproject.context.objects.keys.count)
            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
        })
        
        // TODO: extract build file from build phase
//        XCTContext.runActivity(named: "When append file is exist", block: { _ in
//            let xcodeproject = makeXcodeProject()
//            let appender = make()
//            let originalObjects = xcodeproject.context.objects
//
//            let fileRef = FileRefExtractorImpl(groupExtractor: GroupExtractorImpl()).extract(context: xcodeproject.context, groupPath: "iOSTestProject", fileName: "AppDelegate.swift")!
//
//            XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
//            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
//            appender.append(context: xcodeproject.context, fileRefID: fileRef.id, targetName: "iOSTestProject", fileName: fileRef.path!)
//            XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
//            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.BuildFile }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.BuildFile }.count)
//        })
    }
}
