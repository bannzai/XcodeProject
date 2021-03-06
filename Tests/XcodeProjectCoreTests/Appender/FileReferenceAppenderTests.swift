//
//  FileReferenceAppenderTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/23.
//

import XCTest
@testable import XcodeProjectCore

class FileReferenceAppenderTests: XCTestCase {

    func make() -> FileReferenceAppenderImpl {
        return FileReferenceAppenderImpl()
    }
    
    func testAppend() {
        XCTContext.runActivity(named: "When append file is not exist", block: { _ in
            XCTContext.runActivity(named: "To append root direcotroy", block: { _ in
                let xcodeproject = makeXcodeProject()
                let appender = make()
                let originalObjects = xcodeproject.context.objects
                let originalSubGroupsForMainGroup = xcodeproject.context.mainGroup.subGroups
                
                from: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                    XCTAssertEqual(originalSubGroupsForMainGroup.count, xcodeproject.context.mainGroup.subGroups.count)
                }
                appender.append(context: xcodeproject.context, filePath: "aaaaa.swift")
                to: do {
                    XCTAssertEqual(originalObjects.keys.count + 1, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                    XCTAssertEqual(originalSubGroupsForMainGroup.count, xcodeproject.context.mainGroup.subGroups.count)
                }
            })
            XCTContext.runActivity(named: "To append iOSTestProject/ direcotroy", block: { _ in
                let xcodeproject = makeXcodeProject()
                let appender = make()
                let originalObjects = xcodeproject.context.objects
                let originalSubGroups = xcodeproject.groups[path: "iOSTestProject"]!.subGroups
                
                from: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                    XCTAssertEqual(originalSubGroups.count, xcodeproject.groups[path: "iOSTestProject"]!.subGroups.count)
                }
                appender.append(context: xcodeproject.context, filePath: "iOSTsetProject/aaaaa.swift")
                to: do {
                    XCTAssertEqual(originalObjects.keys.count + 1, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                    XCTAssertEqual(originalSubGroups.count, xcodeproject.groups[path: "iOSTestProject"]!.subGroups.count)
                }
            })
            XCTContext.runActivity(named: "To append Group2/ direcotroy. Group2 is not exists", block: { _ in
                let xcodeproject = makeXcodeProject()
                let appender = make()
                let originalObjects = xcodeproject.context.objects

                from: do {
                    XCTAssertEqual(originalObjects.keys.count, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                }
                appender.append(context: xcodeproject.context, filePath: "Groups2/bbbbb.swift")
                to: do {
                    XCTAssertEqual(originalObjects.keys.count + 1, xcodeproject.context.objects.keys.count)
                    XCTAssertEqual(originalObjects.values.compactMap { $0 as? PBX.FileReference }.count + 1, xcodeproject.context.objects.values.compactMap { $0 as? PBX.FileReference }.count)
                }
            })

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
