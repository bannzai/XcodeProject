//
//  Environment.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/21.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

public enum Environment: String {
    case PROJECT_FILE_PATH
    case TARGET_NAME
    
    case BUILT_PRODUCTS_DIR
    case DEVELOPER_DIR
    case SDKROOT
    case SOURCE_ROOT
    case SRCROOT
    
    fileprivate static var elements: [Environment] {
        return [
            PROJECT_FILE_PATH,
            TARGET_NAME,
            BUILT_PRODUCTS_DIR,
            DEVELOPER_DIR,
            SDKROOT,
            SOURCE_ROOT,
            SRCROOT
        ]
    }
}
