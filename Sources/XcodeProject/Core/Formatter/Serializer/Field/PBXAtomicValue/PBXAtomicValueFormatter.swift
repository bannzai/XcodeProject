//
//  AtomicValueFormatter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public typealias PBXAtomicValueFormatterInformation = (key: PBXRawKeyType, value: PBXRawAtomicValueType, isa: ObjectType)

public protocol PBXAtomicValueFormatter: AutoMockable {
    func format(context: Context, of info: PBXAtomicValueFormatterInformation, in level: Int) -> String
}

public struct PBXAtomicValueFormatterImpl: SerializeFormatter, PBXAtomicValueFormatter {
    public init() {
        
    }
    
    public func format(context: Context, of info: PBXAtomicValueFormatterInformation, in level: Int) -> String {
        let key = info.key
        let value = info.value
        
        let isMultiline = isMultiLine(info.isa)
        let string = try! escape(with: value.pbxValue())
        let isNeedComment = !(key == "remoteGlobalIDString" || key == "TestTargetID")
        let comment = isNeedComment ? wrapComment(context: context, for: string) : ""
        let space = isMultiline ? "" : spaceForOneline
        let content = "\(key) = \(string)\(comment);\(space)"
        return content
    }
}
