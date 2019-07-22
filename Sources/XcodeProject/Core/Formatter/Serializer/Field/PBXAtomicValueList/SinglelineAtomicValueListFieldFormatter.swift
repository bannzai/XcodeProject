//
//  SinglelinePBXAtomicValueListFieldFormatter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public struct SinglelinePBXAtomicValueListFieldFormatter: SerializeFormatter, PBXAtomicValueListFieldFormatterComponent {
    public let project: XcodeProject
    public init(project: XcodeProject) {
        self.project = project
    }
    
    public func format(of info: (key: String, objectIds: [PBXObjectIDType]), level: Int) -> String {
        let key = info.key
        let objectIds = info.objectIds
        
        let content = objectIds
            .map { objectID in
                "\(try! escape(with: objectID))\(wrapComment(for: try! escape(with: objectID))),"
            }
            .joined(separator: spaceForOneline)
        return """
        \(key) = (\(content)\(spaceForOneline));\(spaceForOneline)
        """
    }
}
