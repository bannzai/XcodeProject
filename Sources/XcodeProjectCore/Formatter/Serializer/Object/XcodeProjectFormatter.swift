//
//  XcodeProjectFormatter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public protocol XcodeProjectFormatter {
    func format(project: XcodeProject) -> String
}

public struct XcodeProjectFormatterImpl: XcodeProjectFormatter {
    private let objectRowFormatter: ObjectRowFormatter
    private let otherRowFormatter: TopRowFormatter
    public init(
        objectRowFormatter: ObjectRowFormatter = ObjectRowFormatterImpl(),
        otherRowFormatter: TopRowFormatter = TopRowFormatterImpl()
        ) {
        self.objectRowFormatter = objectRowFormatter
        self.otherRowFormatter = otherRowFormatter
    }
    
    public func format(project: XcodeProject) -> String {
        let content = project.context.allPBX
            .sorted { $0.0 < $1.0 }
            .reduce("") { (lines, pair: (key: String, _: Any)) in
                switch pair.key {
                case "objects":
                    return lines + objectRowFormatter.format(context: project.context)
                case _:
                    return lines + otherRowFormatter.format(context: project.context, key: pair.key)
                }
                
        }
        
        return """
        // !$*UTF8*$!
        {
        \(content)}
        
        """
    }
}
