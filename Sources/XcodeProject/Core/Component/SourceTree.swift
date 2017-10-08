//
//  SourceTree.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/12/23.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

public enum SourceTreeType {
    case group
    case absolute
    case folder(Environment)
    
    init(for sourceTree: String) {
        switch sourceTree {
        case "<group>":
            self = .group
        case "<absolute>":
            self = .absolute
        default:
            guard
                let sourceTreeFolder = Environment(rawValue: sourceTree)
                else {
                    fatalError(
                        assertionMessage(description:
                            "unexpected type",
                            "there is a possibility of the new type",
                            "sourceTreeString: \(sourceTree)"
                        ))
            }
            self = .folder(sourceTreeFolder)
        }
    }
    
    var value: String {
        switch self {
        case .group:
            return "<group>"
        case .absolute:
            return "<absolute>"
        case .folder(let env):
            return env.rawValue
        }
    }
}
