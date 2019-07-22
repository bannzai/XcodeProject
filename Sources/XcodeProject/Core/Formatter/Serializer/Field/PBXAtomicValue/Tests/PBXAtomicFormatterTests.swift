//
//  PBXAtomicFormatterTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/22.
//

import XCTest
@testable import XcodeProject

class PBXAtomicFormatterTests: XCTestCase {
    func make() -> PBXAtomicValueFormatterImpl {
        let project = makeXcodeProject()
        return PBXAtomicValueFormatterImpl(project: project)
    }
    func testFormat() {
        XCTContext.runActivity(named: "And It is single line isa", block: { _ in
            XCTContext.runActivity(named: "And It is needs comment", block: { _ in
                let formatter = make()
                let got = formatter.format(of: (key: "fileRef", value: "BA4268031F89EB7F001FA700", isa: .PBXBuildFile), in: 0)
                XCTAssertEqual(
                    got,
                    "fileRef = BA4268031F89EB7F001FA700 /* AppDelegate.swift */;\(spaceForOneline)"
                )
            })
            XCTContext.runActivity(named: "And It is multiple line isa", block: { _ in
                XCTContext.runActivity(named: "And It is needs comment", block: { _ in
                    let formatter = make()
                    let got = formatter.format(of: (key: "ProductGroup", value: "BAD04C0022E35F61008ADCAD", isa: .PBXProject), in: 0)
                    XCTAssertEqual(
                        got,
                        "ProductGroup = BAD04C0022E35F61008ADCAD /* Products */;"
                    )
                })
            })
            XCTContext.runActivity(named: "And It is not needs comment", block: { _ in
                let formatter = make()
                let got = formatter.format(of: (key: "remoteGlobalIDString", value: "BA4267FF1F89EB7F001FA700", isa: .PBXContainerItemProxy), in: 0)
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
