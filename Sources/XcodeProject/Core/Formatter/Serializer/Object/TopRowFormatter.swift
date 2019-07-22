//
//  TopRowFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public protocol TopRowFormatter {
    func format(key: PBXRawKeyType) -> String
}

public struct TopRowFormatterImpl: SerializeFormatter, TopRowFormatter {
    public let project: XcodeProject
    public init(project: XcodeProject) {
        self.project = project
    }
    
    public func format(key: PBXRawKeyType) -> String {
        let comment = wrapComment(for: key)
        let row = "\(key) = \(project.context.allPBX[key]!)\(comment);"
        let content = row
            .components(separatedBy: newLine)
            .map { r in
                return FormatterIndent.indent + r
            }
            .joined(separator: newLine)
        
        return content + newLine
    }
}
