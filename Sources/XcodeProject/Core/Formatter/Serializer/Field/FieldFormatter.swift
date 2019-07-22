//
//  FieldFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public typealias FieldFormatterInfomation = (key: PBXRawKeyType, value: PBXRawAnyValueType, isa: ObjectType)
public protocol FieldFormatter: SerializeFormatter {
    func format(of info: FieldFormatterInfomation, for level: Int) -> String
}

public struct FieldListFormatterImpl: FieldFormatter {

    public let project: XcodeProject
    private let valueListFormatter: AtomicValueListFieldFormatter
    public init(
        project: XcodeProject,
        valueListFormatter: AtomicValueListFieldFormatter
        ) {
        self.project = project
        self.valueListFormatter = valueListFormatter
    }
    public func format(of info: FieldFormatterInfomation, for level: Int) -> String {
        let key = try! escape(with: info.key)
        let object = info.value
        
        if key == "isa" {
            fatalError("unexcepct isa: \(info.isa)")
        }
        
        switch object {
        case let objectIds as [String]:
            return valueListFormatter.format(of: (key: key, value: objectIds, isa: info.isa), for: level)
        case _:
            fatalError("Not implement")
        }
    }
}

