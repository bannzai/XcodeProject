//
//  GroupAppenderTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/24.
//

import XCTest
@testable import XcodeProjectCore

class GroupAppenderTests: XCTestCase {

    func make() -> GroupAppender {
        return GroupAppenderImpl()
    }
    
    var groupExtractor: GroupExtractor!
    override func setUp() {
        super.setUp()
    }
    
    func testAppend() {
        XCTContext.runActivity(named: "When append file is not exist", block: { _ in
            XCTContext.runActivity(named: "And one directory", block: { _ in
                groupExtractor = GroupExtractorImpl()
                let xcodeproject = makeXcodeProject()
                let appender = make()
                let originalObjects = xcodeproject.context.objects
                let originalSubGroupsForMainGroup = xcodeproject.mainGroup.subGroups
                
                from: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                    XCTAssertEqual(originalSubGroupsForMainGroup.count, xcodeproject.mainGroup.subGroups.count)
                }
                appender.append(context: xcodeproject.context, childrenIDs: [], path: "Hoge")
                to: do {
                    XCTAssertEqual(originalObjects.keys.count + 1, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                    XCTAssertEqual(originalSubGroupsForMainGroup.count + 1, xcodeproject.mainGroup.subGroups.count)
                }
            })
            XCTContext.runActivity(named: "And nested directory", block: { _ in
                groupExtractor = GroupExtractorImpl()
                let xcodeproject = makeXcodeProject()
                let appender = make()
                let originalObjects = xcodeproject.context.objects
                let originalSubGroupsForMainGroup = xcodeproject.mainGroup.subGroups
                
                from: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                    XCTAssertEqual(originalSubGroupsForMainGroup.count, xcodeproject.mainGroup.subGroups.count)
                }
                appender.append(context: xcodeproject.context, childrenIDs: [], path: "Hoge/Fuga")
                to: do {
                    XCTAssertEqual(originalObjects.keys.count + 2, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count + 2, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                    XCTAssertEqual(originalSubGroupsForMainGroup.count + 1, xcodeproject.mainGroup.subGroups.count)
                }
            })
            XCTContext.runActivity(named: "And top level directory is exist, but lower directory is not exists", block: { _ in
                groupExtractor = GroupExtractorImpl()
                let xcodeproject = makeXcodeProject()
                let appender = make()
                let originalObjects = xcodeproject.context.objects
                let originalSubGroupsForMainGroup = xcodeproject.mainGroup.subGroups
                
                from: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                    XCTAssertEqual(originalSubGroupsForMainGroup.count, xcodeproject.mainGroup.subGroups.count)
                }
                appender.append(context: xcodeproject.context, childrenIDs: [], path: "iOSTestProject/Fuga")
                to: do {
                    XCTAssertEqual(originalObjects.keys.count + 1, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                    XCTAssertEqual(originalSubGroupsForMainGroup.count, xcodeproject.mainGroup.subGroups.count)
                }
            })
        })
        
        XCTContext.runActivity(named: "When append file is exist", block: { _ in
            XCTContext.runActivity(named: "And one directory", block: { _ in
                groupExtractor = GroupExtractorImpl()
                let xcodeproject = makeXcodeProject()
                let appender = make()
                let originalObjects = xcodeproject.context.objects
                
                let group = groupExtractor.extract(context: xcodeproject.context, path: "iOSTestProject")
                
                from: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                }
                let result = appender.append(context: xcodeproject.context, childrenIDs: ["aaa"], path: "iOSTestProject")
                to: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                }
                
                XCTAssertEqual(result.id, "BA4268021F89EB7F001FA700")
                XCTAssertEqual(result.id, group!.id)
                XCTAssertEqual(result.children.count, group!.children.count)
            })
            XCTContext.runActivity(named: "And nested directory", block: { _ in
                groupExtractor = GroupExtractorImpl()
                let xcodeproject = makeXcodeProject()
                let appender = make()
                let originalObjects = xcodeproject.context.objects
                
                let group = groupExtractor.extract(context: xcodeproject.context, path: "iOSTestProject/Group")
                
                from: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                }
                let result = appender.append(context: xcodeproject.context, childrenIDs: ["aaa"], path: "iOSTestProject/Group")
                to: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.Group }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.Group }.count)
                }
                
                XCTAssertEqual(result.id, "33467EB722E6C5AE00897582")
                XCTAssertEqual(result.id, group!.id)
                XCTAssertEqual(result.children.count, group!.children.count)
            })
        })
    }

}
