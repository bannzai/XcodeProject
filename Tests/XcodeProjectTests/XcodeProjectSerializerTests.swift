//
//  XcodeProjectSerializerTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import XCTest
@testable import XcodeProject

class XcodeProjectSerializerTests: XCTestCase {
    func make() -> (Context, XcodeProjectSerializer) {
        do {
            let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
            let project = XcodeProject(
                parser: parser,
                hashIDGenerator: PBXObjectHashIDGenerator()
            )
            return (parser.context(), XcodeProjectSerializer(project: project))
        } catch {
            XCTFail(error.localizedDescription)
            fatalError()
        }
    }
    func testSerialize() {
        do {
            let originalContent = try String(contentsOf: xcodeProjectUrl(), encoding: String.Encoding.utf8)
            let (_, serialization) = make()
            let generateString = serialization.serialize()
            
            XCTAssertEqual(originalContent, generateString)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGenerateContentEachSection() {
        XCTContext.runActivity(named: "Single line") { (activity) in
            let (context, serialization) = make()
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
                        allPBX: context
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
        }
        
        XCTContext.runActivity(named: "Multiple line") { (activity) in
            let (context, serialization) = make()
            let got = serialization.generateContentEachSection(
                isa: .PBXContainerItemProxy,
                objects: [
                    PBX.ContainerItemProxy.init(
                        id: "BA4268151F89EB7F001FA700",
                        dictionary: [
                            "isa": "PBXContainerItemProxy",
                            "containerPortal": "BA4267F81F89EB7F001FA700",
                            "proxyType": "1",
                            "remoteGlobalIDString": "BA4267FF1F89EB7F001FA700",
                            "remoteInfo": "iOSTestProject"
                        ],
                        isa: "PBXContainerItemProxy",
                        allPBX: context
                    )
                ]
            )
            XCTAssertEqual(
                got,
                """
                /* Begin PBXContainerItemProxy section */
                \(indent)\(indent)BA4268151F89EB7F001FA700 /* PBXContainerItemProxy */ = {
                \(indent)\(indent)\(indent)isa = PBXContainerItemProxy;
                \(indent)\(indent)\(indent)containerPortal = BA4267F81F89EB7F001FA700 /* Project object */;
                \(indent)\(indent)\(indent)proxyType = 1;
                \(indent)\(indent)\(indent)remoteGlobalIDString = BA4267FF1F89EB7F001FA700;
                \(indent)\(indent)\(indent)remoteInfo = iOSTestProject;
                \(indent)\(indent)};
                /* End PBXContainerItemProxy section */
                
                """
            )
        }
    }
    
    func testGenerateForEachFieldForPairWithISAAndLevel() {
        XCTContext.runActivity(named: "When pairObject not [String], not [PBXPair], not PBXPair] (maybe String).") { _ in
            XCTContext.runActivity(named: "And It is single line", block: { _ in
                
            })
            XCTContext.runActivity(named: "And It is multiple line isa", block: { _ in
                XCTContext.runActivity(named: "And It is not needs comment", block: { _ in
                    let (_, serialization) = make()
                    let got = serialization.generateForEachField(
                        for: (objectKey: "remoteGlobalIDString", pairObject: "BA4267FF1F89EB7F001FA700"),
                        with: .PBXContainerItemProxy,
                        and: 0
                    )
                    XCTAssertEqual(
                        got,
                        """
                        remoteGlobalIDString = BA4267FF1F89EB7F001FA700;
                        """
                    )
                })
            })
        }
    }
}
