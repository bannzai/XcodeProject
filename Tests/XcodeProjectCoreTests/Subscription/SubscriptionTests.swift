//
//  SubscriptionTests.swift
//  XcodeProjectCoreTests
//
//  Created by Yudai Hirose on 2019/07/26.
//

import XCTest
@testable import XcodeProjectCore

class SubscriptionTests: XCTestCase {
    
    func testSubscriptions() {
        XCTContext.runActivity(named: "When abstract class", block: { _ in
            XCTContext.runActivity(named: "And it is not exists", block: { _ in
                let project = makeXcodeProject()
                let object = project.context.objects.values[id: ""]
                XCTAssertNil(object)
            })
            XCTContext.runActivity(named: "And it exists", block: { _ in
                let project = makeXcodeProject()
                let object = project.context.objects.values[id: "33467EB922E6C5B700897582"]
                XCTAssertNotNil(object)
            })
        })
        XCTContext.runActivity(named: "When subclass", block: { _ in
            XCTContext.runActivity(named: "And it is not exists", block: { _ in
                let project = makeXcodeProject()
                let object = project.fileRefs[id: ""]
                XCTAssertNil(object)
            })
            XCTContext.runActivity(named: "And it exists", block: { _ in
                let project = makeXcodeProject()
                let object = project.fileRefs[id: "33467EB922E6C5B700897582"]
                XCTAssertNotNil(object)
            })
        })
    }
}
