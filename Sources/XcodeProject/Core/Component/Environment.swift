//
//  Environment.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/21.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

private extension String {
    func matchFirst(from pattern: String) -> String {
        guard
            let regex = try? NSRegularExpression(pattern: pattern, options: [.useUnixLineSeparators, .caseInsensitive])
            else {
                fatalError(assertionMessage(description: "unexpected pattern: \(pattern)"))
        }
        guard
            let result = regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            else {
                return self
        }
        
        let matchingString = (self as NSString).substring(with: result.range(at: 1)) as String
        
        // FIXME: why last is whitespace??
        if matchingString.characters.last == " " {
            return String(matchingString.characters.dropLast())
        }

        return matchingString
    }
    
    func ignoreCornerSpace() -> String {
        return self.matchFirst(from: "^\\s*(.+)\\s*$")
    }
}

public enum Environment: String {
    case PROJECT_FILE_PATH
    case TARGET_NAME
    
    case BUILT_PRODUCTS_DIR
    case DEVELOPER_DIR
    case SDKROOT
    case SOURCE_ROOT
    case SRCROOT
    
    public static func convert(from content: String) -> [String: String] {
        let environments = content.components(separatedBy: "\n")
        var dictionary: [String: String] = [:]
        environments.forEach { env in
            let classes = env.components(separatedBy: "=")
            switch classes.first {
            case .none:
                return 
            case .some(let left):
                let right = classes.count == 2 ? classes[1] : ""
                let key = left.ignoreCornerSpace()
                let value = right.ignoreCornerSpace()
                
                dictionary[key] = value
            }
        }
        return dictionary
    }
    
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
