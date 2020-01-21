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
            fatalError("Can not find file path. PBXProjectPath: \(String(describing: ProcessInfo().environment["PBXProjectPath"])) ")
    }
    
    return url
}
extension Context {
    var grouped: [String: [PBX.Object]] {
        return self.dictionary
            .values
            .toArray()
            .groupBy { $0.isa.rawValue }
    }
}
