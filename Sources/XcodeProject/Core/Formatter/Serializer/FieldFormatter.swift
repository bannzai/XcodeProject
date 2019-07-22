//
//  FieldFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public typealias FieldFormatterInfomation = (key: PBXRawKeyType, value: PBXRawAnyValueType, isa: ObjectType)
public protocol FieldFormatter {
    func format(of info: FieldFormatterInfomation, for level: Int) -> String
}


// MARK: - Serializer formatter helper functions
public struct FormatterIndent {
    static internal let indent = "\t"
    static internal let newLine = "\n"
    static internal let spaceForOneline = " "
}

func _indent(for level: Int) -> String {
    var ret = ""
    for _ in 0..<level {
        ret += FormatterIndent.indent
    }
    return ret
}

func _isMultiLine(isa: ObjectType) -> Bool {
    switch isa {
    case .PBXBuildFile, .PBXFileReference:
        return false
    default:
        return true
    }
}

