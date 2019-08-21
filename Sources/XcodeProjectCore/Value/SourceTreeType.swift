//
//  SourceTree.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/12/23.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

// SourceTreeType is a show path of localion on file systems for each PBX elements.
public enum SourceTreeType {
    
    // Environment are describe the elements required for XcodeProject.
    public enum Environment: String, CaseIterable {
        case PROJECT_FILE_PATH
        case TARGET_NAME
        
        case BUILT_PRODUCTS_DIR
        case DEVELOPER_DIR
        case SDKROOT
        case SOURCE_ROOT
        case SRCROOT
    }
    
    case group
    case absolute
    case environment(Environment)
    
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
            self = .environment(sourceTreeFolder)
        }
    }
    
    var value: String {
        switch self {
        case .group:
            return "<group>"
        case .absolute:
            return "<absolute>"
        case .environment(let env):
            return env.rawValue
        }
    }
}

extension SourceTreeType.Environment: Equatable {
    
}

extension SourceTreeType: Equatable {
    
}
