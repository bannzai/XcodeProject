//
//  PBXMapFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public typealias PBXRawMapFormatterInformation = (key: PBXRawKeyType, value: PBXRawMapType, isa: ObjectType)

public protocol PBXRawMapFormatter: SerializeFormatter {
    func format(
        of info: PBXRawMapFormatterInformation,
        in level: Int,
        next nextFormatter: FieldFormatter
        ) -> String
}

public struct PBXRawMapFormatterImpl: PBXRawMapFormatter {
    public let project: XcodeProject
    public init(project: XcodeProject) {
        self.project = project
    }
    
    public func format(
        of info: PBXRawMapFormatterInformation,
        in level: Int,
        next nextFormatter: FieldFormatter
        ) -> String {
        let key = info.key
        let map = info.value
        
        let content = map
            .sorted { $0.0 < $1.0 }
            .compactMap { key, value in
                return """
                \(indent(level + 1))\(nextFormatter.format(of: (key: key, value: value, isa: info.isa), for: level + 1))
                """
            }
            .joined(separator: newLine)
        return """
        \(key) = {
        \(content)
        \(indent(level))};
        """
    }
}
