//
//  XcodeProjectSerializerTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import XCTest
@testable import XcodeProject

class XcodeProjectSerializerTests: XCTestCase {
    func testSerialize() {
        do {
            let originalContent = try String(contentsOf: xcodeProjectUrl(), encoding: String.Encoding.utf8)
            
            let project = XcodeProject(
                parser: try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl()),
                hashIDGenerator: PBXObjectHashIDGenerator()
            )
            let serialization = XcodeProjectSerializer(project: project)
            let generateString = serialization.serialize()
            
            XCTAssertEqual(originalContent, generateString)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGenerateContentEachSection() {
        do {
            let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
            let project = XcodeProject(
                parser: parser,
                hashIDGenerator: PBXObjectHashIDGenerator()
            )
            let serialization = XcodeProjectSerializer(project: project)
            let got = serialization.generateContentEachSection(
                isa: .PBXBuildFile,
                objects: [
                    PBX.BuildFile.init(
                        id: "BA4268041F89EB7F001FA700",
                        dictionary: [
                            "isa": "PBXBuildFile",
                            "fileRef": "BA4268031F89EB7F001FA700",
                        ],
                        isa: "PBXBuildFile",
                        allPBX: parser.context()
                    )
                ]
            )
            XCTAssertEqual(
                got,
                """
/* Begin PBXBuildFile section */
\(indent)\(indent)BA4268041F89EB7F001FA700 /* AppDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = BA4268031F89EB7F001FA700 /* AppDelegate.swift */; };
/* End PBXBuildFile section */

"""
            )
        } catch {
            XCTFail(error.localizedDescription)
        }

    }
}
