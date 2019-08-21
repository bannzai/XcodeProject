//
//  XcodeProjectSyncTests.swift
//  XcodeProjectCoreTests
//
//  Created by Yudai Hirose on 2019/08/20.
//

import XCTest
@testable import XcodeProjectCore

class XcodeProjectSyncTests: XCTestCase {

    func testExpectedFileFullPath() {
        XCTContext.runActivity(named: "in group") { (_) in
            let xcodeproject = makeXcodeProject()
            let result = xcodeproject.expectedFileReferenceFullPath(xcodeproject.fileRefs[path: "AppDelegate.swift"]!)
            
            XCTAssertEqual(result, xcodeproject.context.xcodeprojectDirectoryURL.path + "/iOSTestProject/AppDelegate.swift")
        }
        XCTContext.runActivity(named: "in group with no reference file") { (_) in
            let xcodeproject = makeXcodeProject()
            let result = xcodeproject.expectedFileReferenceFullPath(xcodeproject.fileRefs.filter { $0.name == "NoReferenceFile.swift" }.first!)
            
            XCTAssertEqual(result, xcodeproject.context.xcodeprojectDirectoryURL.path + "/iOSTestProject/NoReferenceGroup/NoReferenceFile.swift")
        }
        XCTContext.runActivity(named: "in nested group") { (_) in
            let xcodeproject = makeXcodeProject()
            let result = xcodeproject.expectedFileReferenceFullPath(xcodeproject.fileRefs[path: "FileReference.swift"]!)
            
            XCTAssertEqual(result, xcodeproject.context.xcodeprojectDirectoryURL.path + "/iOSTestProject/Group/FileReference.swift")
        }
    }
    
    func testFileFullPath() {
        XCTContext.runActivity(named: "in group") { (_) in
            let xcodeproject = makeXcodeProject()
            let result = xcodeproject.fileReferenceFullPath(xcodeproject.fileRefs[path: "AppDelegate.swift"]!)
            
            XCTAssertEqual(result, xcodeproject.context.xcodeprojectDirectoryURL.path + "/iOSTestProject/AppDelegate.swift")
        }
        XCTContext.runActivity(named: "in group with no reference file") { (_) in
            let xcodeproject = makeXcodeProject()
            let result = xcodeproject.fileReferenceFullPath(xcodeproject.fileRefs.filter { $0.name == "NoReferenceFile.swift" }.first!)
            
            XCTAssertEqual(result, xcodeproject.context.xcodeprojectDirectoryURL.path + "/iOSTestProject/NoReferenceFile.swift")
        }
        XCTContext.runActivity(named: "in nested group") { (_) in
            let xcodeproject = makeXcodeProject()
            let result = xcodeproject.fileReferenceFullPath(xcodeproject.fileRefs[path: "FileReference.swift"]!)
            
            XCTAssertEqual(result, xcodeproject.context.xcodeprojectDirectoryURL.path + "/iOSTestProject/Group/FileReference.swift")
        }
    }
    
    func testExpectedDirectoryFullPath() {
        XCTContext.runActivity(named: "in group") { (_) in
            let xcodeproject = makeXcodeProject()
            let result = xcodeproject.expectedDirectoryFullPath(xcodeproject.groups[fullPath: "iOSTestProject"]!)
            
            XCTAssertEqual(result, xcodeproject.context.xcodeprojectDirectoryURL.path + "/iOSTestProject")
        }
        XCTContext.runActivity(named: "in group with no reference directory") { (_) in
            let xcodeproject = makeXcodeProject()
            let result = xcodeproject.expectedDirectoryFullPath(xcodeproject.groups.filter { $0.name == "NoReferenceGroup" }.first!)
            
            XCTAssertEqual(result, xcodeproject.context.xcodeprojectDirectoryURL.path + "/iOSTestProject/NoReferenceGroup")
        }
        XCTContext.runActivity(named: "in nested group") { (_) in
            let xcodeproject = makeXcodeProject()
            let result = xcodeproject.expectedDirectoryFullPath(xcodeproject.groups[fullPath: "iOSTestProject/Group"]!)
            
            XCTAssertEqual(result, xcodeproject.context.xcodeprojectDirectoryURL.path + "/iOSTestProject/Group")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
