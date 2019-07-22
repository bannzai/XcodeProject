//
//  MultiplelineAtomicValueListFieldFormatter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public struct MultiplelineAtomicValueListFieldFormatter: AtomicValueListFieldFormatterComponent {
    public let project: XcodeProject
    public init(project: XcodeProject) {
        self.project = project
    }
    
    public func format(of info: (key: String, objectIds: [PBXObjectIDType]), level: Int) -> String {
        let key = info.key
        let objectIds = info.objectIds
        
        switch  objectIds.isEmpty {
        case true:
            return """
            \(key) = (
            \(indent(level)));
            """
        case false:
            let content = objectIds
                .map { objectID in
                    "\(indent(level + 1))\(try! escape(with: objectID))\(wrapComment(for: try! escape(with: objectID))),"
                }
                .joined(separator: newLine)
            return """
            \(key) = (
            \(content)
            \(indent(level)));
            """
        }
    }
}