//
//  XcodeProjectSerializerTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import XCTest
@testable import XcodeProject
import Swdifft

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
            
            print(generateString)
            print(originalContent)
            XCTAssertEqual(originalContent, generateString)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testEscapeWithTarget() {
        XCTContext.runActivity(named: "A", block: { _ in
            do {
                let (_, serialization) = make()

                let input = "\"# Type a script or drag a script file from your workspace to insert its path.\necho \"Script\"\n\""
                let expected = "\"\\\"# Type a script or drag a script file from your workspace to insert its path.\\necho \\\"Script\\\"\\n\\\"\""
                let got = try serialization.escape(with: input)
                
                XCTAssertEqual(got, expected, formatDiff(got, expected))
            } catch {
                XCTFail(error.localizedDescription)
            }
        })
    }
    
    func testGenerateContentEachSection() {
        XCTContext.runActivity(named: "Single line") { (activity) in
            XCTContext.runActivity(named: "When PBXShellScriptBuildPhase") { (_) in
                let (context, serialization) = make()
                let got = serialization.generateContentEachSection(
                    isa: .PBXShellScriptBuildPhase,
                    objects: [
                        PBX.ShellScriptBuildPhase.init(
                            id: "33D083C322DE32F300ED246F",
                            dictionary: [
                                "isa": "PBXShellScriptBuildPhase",
                                "buildActionMask": 2147483647,
                                "files": [Any](),
                                "inputFileListPaths": [Any](),
                                "inputPaths": [Any](),
                                "name": "Single Line Script",
                                "outputFileListPaths": [Any](),
                                "outputPaths": [Any](),
                                "runOnlyForDeploymentPostprocessing": 0,
                                "shellPath": "/bin/sh",
                                "shellScript": "# Type a script or drag a script file from your workspace to insert its path.\necho \"Script\"\n"
                            ],
                            isa: ObjectType.PBXShellScriptBuildPhase.rawValue,
                            allPBX: context
                        ),
                    ]
                )
                XCTAssertEqual(
                    got,
                    """
                    /* Begin PBXShellScriptBuildPhase section */
                    \(indent)\(indent)33D083C322DE32F300ED246F /* Single Line Script */ = {
                    \(indent)\(indent)\(indent)isa = PBXShellScriptBuildPhase;
                    \(indent)\(indent)\(indent)buildActionMask = 2147483647;
                    \(indent)\(indent)\(indent)files = (
                    \(indent)\(indent)\(indent));
                    \(indent)\(indent)\(indent)inputFileListPaths = (
                    \(indent)\(indent)\(indent));
                    \(indent)\(indent)\(indent)inputPaths = (
                    \(indent)\(indent)\(indent));
                    \(indent)\(indent)\(indent)name = "Single Line Script";
                    \(indent)\(indent)\(indent)outputFileListPaths = (
                    \(indent)\(indent)\(indent));
                    \(indent)\(indent)\(indent)outputPaths = (
                    \(indent)\(indent)\(indent));
                    \(indent)\(indent)\(indent)runOnlyForDeploymentPostprocessing = 0;
                    \(indent)\(indent)\(indent)shellPath = /bin/sh;
                    \(indent)\(indent)\(indent)shellScript = "# Type a script or drag a script file from your workspace to insert its path.\\necho \\\"Script\\\"\\n";
                    \(indent)\(indent)};
                    /* End PBXShellScriptBuildPhase section */
                    
                    """
                )
            }
            
            XCTContext.runActivity(named: "When PBXBuildFile") { (_) in
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
        XCTContext.runActivity(named: "When pairObject is [String].") { _ in
            XCTContext.runActivity(named: "And It is single line isa", block: { _ in
                let (_, serialization) = make()
                let got = serialization.generateForEachField(
                    for: (objectKey: "ATTRIBUTES", pairObject: ["CodeSignOnCopy", "RemoveHeadersOnCopy"]),
                    with: .PBXBuildFile,
                    and: 0
                )
                XCTAssertEqual(
                    got,
                    "ATTRIBUTES = (CodeSignOnCopy, RemoveHeadersOnCopy, ); "
                )
            })
            XCTContext.runActivity(named: "And It is multiple line isa", block: { _ in
                let (_, serialization) = make()
                let got = serialization.generateForEachField(
                    for: (objectKey: "files", pairObject: ["BA42680E1F89EB7F001FA700", "BA42680B1F89EB7F001FA700", "BA4268091F89EB7F001FA700"]),
                    with: .PBXResourcesBuildPhase,
                    and: 0
                )
                XCTAssertEqual(
                    got,
                    """
                    files = (
                    \(indent)BA42680E1F89EB7F001FA700 /* LaunchScreen.storyboard in Resources */,
                    \(indent)BA42680B1F89EB7F001FA700 /* Assets.xcassets in Resources */,
                    \(indent)BA4268091F89EB7F001FA700 /* Main.storyboard in Resources */,
                    );
                    """
                )
            })
        }
        
        XCTContext.runActivity(named: "When pairObject is [PBXPair].") { _ in
            XCTContext.runActivity(named: "And It is multiple line isa", block: { _ in
                let (_, serialization) = make()
                let got = serialization.generateForEachField(
                    for: (objectKey: "projectReferences", pairObject: [
                        ["ProductGroup": "BAD04C0022E35F61008ADCAD", "ProjectRef": "BAD04BFF22E35F61008ADCAD"],
                        ]
                    ),
                    with: .PBXProject,
                    and: 0
                )
                XCTAssertEqual(
                    got,
                    """
                    projectReferences = (
                    \(indent){
                    \(indent)\(indent)ProductGroup = BAD04C0022E35F61008ADCAD /* Products */;
                    \(indent)\(indent)ProjectRef = BAD04BFF22E35F61008ADCAD /* ReferenceProject.xcodeproj */;
                    \(indent)},
                    );
                    """
                )
            })
        }
        
        XCTContext.runActivity(named: "When pairObject is not [String], not [PBXPair], not PBXPair] (maybe String).") { _ in
            XCTContext.runActivity(named: "And It is single line isa", block: { _ in
                XCTContext.runActivity(named: "And It is needs comment", block: { _ in
                    let (_, serialization) = make()
                    let got = serialization.generateForEachField(
                        for: (objectKey: "fileRef", pairObject: "BA4268031F89EB7F001FA700"),
                        with: .PBXBuildFile,
                        and: 0
                    )
                    XCTAssertEqual(
                        got,
                        "fileRef = BA4268031F89EB7F001FA700 /* AppDelegate.swift */;\(spaceForOneline)"
                    )
                })
            XCTContext.runActivity(named: "And It is multiple line isa", block: { _ in
                XCTContext.runActivity(named: "And It is needs comment", block: { _ in
                    let (_, serialization) = make()
                    let got = serialization.generateForEachField(
                        for: (objectKey: "ProductGroup", pairObject: "BAD04C0022E35F61008ADCAD"),
                        with: .PBXProject,
                        and: 0
                    )
                    XCTAssertEqual(
                        got,
                        "ProductGroup = BAD04C0022E35F61008ADCAD /* Products */;"
                    )
                })
            })
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
