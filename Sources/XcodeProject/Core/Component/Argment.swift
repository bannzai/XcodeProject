//
//  argment.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/20.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

struct Argument {
    static func projectDirectory() -> String? {
        let components = ProcessInfo
            .processInfo
            .arguments
            .filter { $0.range(of: "--project ") != nil }
            .flatMap { $0.components(separatedBy: " ") }
        
        if components.isEmpty {
            return nil
        }
        
        let targetIndex = ((components.index(of: "--project"))! + 1) 
        
        return components[targetIndex]
    }
    
}
