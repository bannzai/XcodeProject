//
//  FileReferenceAppenderTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/23.
//

import XCTest
@testable import XcodeProject

class FileReferenceAppenderTests: XCTestCase {

    func make() -> FileReferenceAppenderImpl {
        return FileReferenceAppenderImpl(
            hashIDGenerator: PBXObjectHashIDGenerator(),
            fileRefExtractor: FileRefExtractorImpl(groupExtractor: GroupExtractorImpl()),
            groupExtractor: GroupExtractorImpl()
        )
    }
    
    func testAppend() {
        XCTContext.runActivity(named: "When append file is not exist", block: { _ in
            let xcodeproject = makeXcodeProject()
            let appender = make()
            let originalObjects = xcodeproject.context.objects
            
            XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
            appender.append(context: xcodeproject.context, filePath: "aaaaa.swift")
            XCTAssertNotEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
            XCTAssertNotEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
        })
        
        XCTContext.runActivity(named: "When append file is exist", block: { _ in
            let xcodeproject = makeXcodeProject()
            let appender = make()
            let originalObjects = xcodeproject.context.objects
            
            XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
            appender.append(context: xcodeproject.context, filePath: "iOSTestProject/AppDelegate.swift")
            XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
            XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
        })
    }
}
