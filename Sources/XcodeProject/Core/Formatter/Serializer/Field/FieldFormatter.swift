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
    private let mapListFormatter: PBXRawMapListFormatter
    public init(
        project: XcodeProject,
        valueListFormatter: AtomicValueListFieldFormatter,
        mapListFormatter: PBXRawMapListFormatter
        ) {
        self.project = project
        self.valueListFormatter = valueListFormatter
        self.mapListFormatter = mapListFormatter
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
        case let mapList as [PBXRawMapType]:
            return mapListFormatter.format(of: (key: key, value: mapList, isa: info.isa), in: level, next: self)
        case _:
            fatalError("Not implement")
        }
    }
}

