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
            groupExtractor: GroupExtractorImpl()
        )
    }
    
    func testAppend() {
        let xcodeproject = makeXcodeProject()
        let appender = make()
        let originalObjects = xcodeproject.context.objects
        
        XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
        XCTAssertEqual(originalObjects.values.count, xcodeproject.context.objects.values.count)
        appender.append(context: xcodeproject.context, filePath: "aaaaa.swift")
        XCTAssertNotEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
        XCTAssertNotEqual(originalObjects.values.count, xcodeproject.context.objects.values.count)
    }
}
