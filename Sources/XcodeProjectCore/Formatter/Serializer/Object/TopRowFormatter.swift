//
//  TopRowFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public protocol TopRowFormatter {
    func format(context: Context, key: PBXRawKeyType) -> String
}

public struct TopRowFormatterImpl: SerializeFormatter, TopRowFormatter {
    public init() {
        
    }
    
    public func format(context: Context, key: PBXRawKeyType) -> String {
        let comment = wrapComment(context: context, for: key)
        let row = "\(key) = \(context.allPBX[key]!)\(comment);"
        let content = row
            .components(separatedBy: newLine)
            .map { r in
                return FormatterIndent.indent + r
            }
            .joined(separator: newLine)
        
        return content + newLine
    }
}
