//
//  PBXRawMapFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public typealias PBXRawMapListFormatterInformation = (key: PBXRawKeyType, value: [PBXRawMapType], isa: ObjectType)

public protocol PBXRawMapListFormatter: SerializeFormatter {
    func format(
        context: Context,
        of info: PBXRawMapListFormatterInformation,
        in level: Int,
        next nextFormatter: FieldFormatter
    ) -> String
}

public struct PBXRawMapListFormatterImpl: PBXRawMapListFormatter {
    public init() {
    }
    
    public func format(
        context: Context,
        of info: PBXRawMapListFormatterInformation,
        in level: Int,
        next nextFormatter: FieldFormatter
        ) -> String {
        let key = info.key
        let mapList = info.value
        
        let content = mapList
            .map { pair -> String in
                let generateForEachFields = pair
                    .sorted { $0.0 < $1.0 }
                    .map { key, value in
                        return """
                        \(indent(level + 2))\(nextFormatter.format(context: context, of: (key: key, value: value, isa: info.isa), for: level + 1))
                        """
                    }
                    .joined(separator: newLine)
                return """
                \(indent(level + 1)){
                \(generateForEachFields)
                \(indent(level + 1))},
                """
            }
            .joined(separator: "")
        
        return """
        \(key) = (
        \(content)
        \(indent(level)));
        """
    }
}
