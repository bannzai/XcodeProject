//
//  PBXRawMapListFormatterTests.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/22.
//

import XCTest
@testable import XcodeProjectCore

class PBXRawMapListFormatterTests: XCTestCase{
    func make() -> (FieldFormatter, PBXRawMapListFormatterImpl) {
        let nextFormatter = FieldListFormatterImpl()
        return (nextFormatter, PBXRawMapListFormatterImpl())
    }
    
    func testFormat() {
        XCTContext.runActivity(named: "And It is multiple line isa", block: { _ in
            let project = makeXcodeProject()
            let (next, formatter) = make()
            let got = formatter.format(
                context: project.context,
                of: (
                    key: "projectReferences",
                    value: [ ["ProductGroup": "BAD04C0022E35F61008ADCAD", "ProjectRef": "BAD04BFF22E35F61008ADCAD"],
                    ],
                    isa: .PBXProject
                ),
                in: 0,
                next: next
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
}
