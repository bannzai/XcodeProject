//
//  SectionFormatterTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/22.
//

import XCTest
@testable import XcodeProject

class SectionFormatterTests: XCTestCase {
    func make() -> SectionFormatter {
        let fieldFormatter = makeFieldFormatter()
        return SectionFormatterImpl(
            project: fieldFormatter.project,
            rowFormatter: SectionRowFormatterImpl(
                project: fieldFormatter.project,
                fieldFormatter: fieldFormatter
            )
        )
    }
    
    func testFormat(){
        XCTContext.runActivity(named: "Single line") { (activity) in
            XCTContext.runActivity(named: "When PBXShellScriptBuildPhase") { (_) in
                let formatter = make()
                let got = formatter.format(
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
                            context: formatter.project.context
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
                let formatter = make()
                let got = formatter.format(
                    isa: .PBXBuildFile,
                    objects: [
                        PBX.BuildFile.init(
                            id: "BA4268041F89EB7F001FA700",
                            dictionary: [
                                "isa": "PBXBuildFile",
                                "fileRef": "BA4268031F89EB7F001FA700",
                            ],
                            isa: "PBXBuildFile",
                            context: formatter.project.context
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
            let formatter = make()
            let got = formatter.format(
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
                        context: formatter.project.context
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
}
