//
//  Test.swift
//  xcp
//
//  Created by Hirose.Yudai on 2016/12/16.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation


struct Test {
    func testWrite() {
        guard
            let testPath = ProcessInfo().environment["PBXProjectPath"],
            let url = URL(string: "file://" + testPath)
            else {
                fatalError(assertionMessage(description: "Should set environment PBXProjectPath."))
        }
        
        let string = try! String(contentsOf: url, encoding: String.Encoding.utf8)
        let project = try! XCProject(for: url)
        let serialization = XCPSerialization(project: project)
        let generateString = try! serialization.generateWriteContent()
        
        if string != generateString {
            fatalError("unexception should same read and write content")
        }
        
        print("success: \(#function)")
    }
}
