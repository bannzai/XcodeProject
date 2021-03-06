//
//  SectionRowFormatter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public typealias SectionRowFormatterInformation = (object: PBX.Object, isa: ObjectType)
public protocol SectionRowFormatter: SerializeFormatter {
    func format(context: Context, of info: SectionRowFormatterInformation) -> String
}

public struct SectionRowFormatterImpl: SectionRowFormatter {
    private let fieldFormatter: FieldFormatter
    public init(
        fieldFormatter: FieldFormatter = FieldListFormatterImpl()
        ) {
        self.fieldFormatter = fieldFormatter
    }
    
    public func format(context: Context, of info: SectionRowFormatterInformation) -> String {
        let (object, isa) = info
        
        let headLevel = 2
        let nestedLevel = 3
        let isMultiline = isMultiLine(isa)
        let comment = wrapComment(context: context, for: object.id)
        let isaValue = "isa = \(isa.rawValue);"
        
        let objectPair = object.objectDictionary
            .sorted { $0.0 < $1.0 }
            .compactMap { (key: String, value: Any) -> String? in
                if key == "isa" {
                    // skip
                    return nil
                }
                
                let content = fieldFormatter.format(context: context, of: (key: key, value: value, isa: isa), for: nestedLevel)
                if content.isEmpty {
                    return nil
                }
                return indent(isMultiline ? nestedLevel : 0) + content
            }.joined(separator: isMultiline ? newLine : "")
        
        switch isMultiline {
        case true:
            return """
            \(indent(headLevel))\(object.id)\(comment) = {
            \(indent(nestedLevel))\(isaValue)
            \(objectPair)
            \(indent(headLevel))};
            """
        case false:
            return """
            \(indent(headLevel))\(object.id)\(comment) = {\(isaValue)\(spaceForOneline)\(objectPair)};
            """
        }
        
    }
}
