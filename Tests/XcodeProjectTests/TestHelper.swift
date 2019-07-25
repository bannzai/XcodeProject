//
//  TestHelper.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation
import XCTest
@testable import XcodeProject

func xcodeProjectUrl() -> URL {
    guard
        let testPath = ProcessInfo().environment["PBXProjectPath"],
        let url = URL(string: "file://" + testPath)
        else {
            XCTFail("Should set environment PBXProjectPath.")
            fatalError()
    }
    
    return url
}

func projectRootPath() -> URL {
    guard
        let testPath = ProcessInfo().environment["PBXProjectPath"],
        let url = URL(
            string: String(
                testPath
                    .components(separatedBy: "/")
                    .dropLast() // drop project.pbxproj
                    .dropLast() // drop PROJECTNAME.xcodeproj
                    .joined(separator: "/")
            ) + "/"
        )
        else {
            XCTFail("Should set environment PBXProjectPath.")
            fatalError()
    }
    
    return url
}

func makeXcodeProject() -> XcodeProject {
    do {
        let project = try XcodeProject(
            xcodeprojectURL: xcodeProjectUrl()
        )
        return project
    } catch {
        XCTFail(error.localizedDescription)
        fatalError()
    }
}

extension Context {
    var grouped: [String: [PBX.Object]] {
        return self.objects
            .values
            .toArray()
            .groupBy { $0.isa.rawValue }
    }
}
