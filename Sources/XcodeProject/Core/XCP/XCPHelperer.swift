//
//  XCPHelperer.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/12/23.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

func assertionMessage(
    with function: String = #function,
         file: String = #file,
         line: Int = #line,
         description: String ...
    ) -> String {
    
    return [
        "function: \(function)",
        "file: \(file)",
        "line: \(line)",
        "description: \(description)",
        ].joined(separator: "\n")
}

