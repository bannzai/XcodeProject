//
//  AtomicValueFormatter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public typealias PBXAtomicValueFormatterInformation = (key: PBXRawKeyType, value: PBXRawAtomicValueType, isa: ObjectType)

public protocol PBXAtomicValueFormatter: SerializeFormatter {
    func format(of info: PBXAtomicValueFormatterInformation, in level: Int) -> String
}

public struct PBXAtomicValueFormatterImpl: PBXAtomicValueFormatter {
    public let project: XcodeProject
    public init(project: XcodeProject) {
        self.project = project
    }
    
    public func format(of info: PBXAtomicValueFormatterInformation, in level: Int) -> String {
        let key = info.key
        let value = info.value
        
        let isMultiline = isMultiLine(info.isa)
        let string = try! escape(with: value.pbxValue())
        let isNeedComment = !(key == "remoteGlobalIDString" || key == "TestTargetID")
        let comment = isNeedComment ? wrapComment(for: string) : ""
        let space = isMultiline ? "" : spaceForOneline
        let content = "\(key) = \(string)\(comment);\(space)"
        return content
    }
}
