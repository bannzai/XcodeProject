//
//  XcodeProjectFormatter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public protocol XcodeProjectFormatter {
    func format(with project: XcodeProject) -> String
}

public struct XcodeProjectFormatterImpl: XcodeProjectFormatter {
    private let objectRowFormatter: ObjectRowFormatter
    private let otherRowFormatter: TopRowFormatter
    public init(
        objectRowFormatter: ObjectRowFormatter,
        otherRowFormatter: TopRowFormatter
        ) {
        self.objectRowFormatter = objectRowFormatter
        self.otherRowFormatter = otherRowFormatter
    }
    
    public func format(with project: XcodeProject) -> String {
        let content = project.fullPair
            .sorted { $0.0 < $1.0 }
            .reduce("") { (lines, pair: (key: String, _: Any)) in
                switch pair.key {
                case "objects":
                    return lines + objectRowFormatter.format(context: project.allPBX)
                case _:
                    return lines + otherRowFormatter.format(key: pair.key)
                }
                
        }
        
        return """
        // !$*UTF8*$!
        {
        \(content)}
        
        """
    }
}
