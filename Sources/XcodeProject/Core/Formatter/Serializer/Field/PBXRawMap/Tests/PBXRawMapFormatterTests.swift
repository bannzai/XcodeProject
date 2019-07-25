//
//  PBXRawMapFormatterTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/22.
//

import XCTest
@testable import XcodeProject

class PBXRawMapFormatterTests: XCTestCase {
    func make() -> (FieldFormatter, PBXRawMapFormatterImpl) {
        let nextFormatter = makeFieldFormatter()
        return (nextFormatter, PBXRawMapFormatterImpl())
    }

    func testFormat() {
        XCTContext.runActivity(named: "And It is multiple line isa", block: { _ in
            let project = makeXcodeProject()
            let (next, formatter) = make()
            let got = formatter.format(
                context: project.context,
                of: (
                    key: "attributes",
                    value: [
                        "LastSwiftUpdateCheck": "0900",
                        "LastUpgradeCheck": "0900",
                        "ORGANIZATIONNAME": "廣瀬雄大",
                        "TargetAttributes": [
                            "BA4267FF1F89EB7F001FA700": [
                                "CreatedOnToolsVersion": "9.0",
                                "ProvisioningStyle": "Automatic",
                            ],
                            "BA4268131F89EB7F001FA700": [
                                "CreatedOnToolsVersion": "9.0",
                                "ProvisioningStyle": "Automatic",
                                "TestTargetID": "BA4267FF1F89EB7F001FA700",
                            ],
                            "BA42681E1F89EB7F001FA700": [
                                "CreatedOnToolsVersion": "9.0",
                                "ProvisioningStyle": "Automatic",
                                "TestTargetID": "BA4267FF1F89EB7F001FA700",
                            ],
                        ]
                    ],
                    isa: .PBXProject
                ),
                in: 0,
                next: next
            )
            XCTAssertEqual(
                got,
                """
                attributes = {
                \(indent)LastSwiftUpdateCheck = 0900;
                \(indent)LastUpgradeCheck = 0900;
                \(indent)ORGANIZATIONNAME = "廣瀬雄大";
                \(indent)TargetAttributes = {
                \(indent)\(indent)BA4267FF1F89EB7F001FA700 = {
                \(indent)\(indent)\(indent)CreatedOnToolsVersion = 9.0;
                \(indent)\(indent)\(indent)ProvisioningStyle = Automatic;
                \(indent)\(indent)};
                \(indent)\(indent)BA4268131F89EB7F001FA700 = {
                \(indent)\(indent)\(indent)CreatedOnToolsVersion = 9.0;
                \(indent)\(indent)\(indent)ProvisioningStyle = Automatic;
                \(indent)\(indent)\(indent)TestTargetID = BA4267FF1F89EB7F001FA700;
                \(indent)\(indent)};
                \(indent)\(indent)BA42681E1F89EB7F001FA700 = {
                \(indent)\(indent)\(indent)CreatedOnToolsVersion = 9.0;
                \(indent)\(indent)\(indent)ProvisioningStyle = Automatic;
                \(indent)\(indent)\(indent)TestTargetID = BA4267FF1F89EB7F001FA700;
                \(indent)\(indent)};
                \(indent)};
                };
                """
            )
        })
        
    }
}
