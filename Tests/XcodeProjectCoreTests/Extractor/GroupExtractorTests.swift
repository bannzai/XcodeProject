//
//  GroupExtractorTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/25.
//

import XCTest
@testable import XcodeProjectCore

class GroupExtractorTests: XCTestCase {
    func make() -> GroupExtractor {
        return GroupExtractorImpl()
    }

    
    func testExtract() {
        XCTContext.runActivity(named: "When is not exists directory", block: { _ in
            XCTContext.runActivity(named: "When is Hoge directory. Hoge is not exists", block: { _ in
                let xcodeProject = makeXcodeProject()
                let extractor = make()
                
                let group = extractor.extract(context: xcodeProject.context, path: "Hoge")
                
                XCTAssertNil(group)
            })
        })
        XCTContext.runActivity(named: "When is exists directory", block: { _ in
            XCTContext.runActivity(named: "When is root directory", block: { _ in
                let xcodeProject = makeXcodeProject()
                let extractor = make()
                
                let group = extractor.extract(context: xcodeProject.context, path: "")
                
                XCTAssertNotNil(group)
                XCTAssertEqual(group!.path, nil)
                XCTAssertEqual(group!.name, nil)
            })
            XCTContext.runActivity(named: "When is not root directory", block: { _ in
                let xcodeProject = makeXcodeProject()
                let extractor = make()
                
                let group = extractor.extract(context: xcodeProject.context, path: "iOSTestProject")
                
                XCTAssertNotNil(group)
                XCTAssertEqual(group!.path!, "iOSTestProject")
            })
        })
    }
}
