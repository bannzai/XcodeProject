//
//  PBXAtomicValueListFieldFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public typealias PBXAtomicValueListFieldFormatterInfomation = (key: PBXRawKeyType, value: [PBXRawAtomicValueType], isa: ObjectType)

public protocol PBXAtomicValueListFieldFormatter: AutoMockable {
    func format(of info: PBXAtomicValueListFieldFormatterInfomation, for level: Int) -> String
}

public struct PBXAtomicValueListFieldFormatterImpl: SerializeFormatter, PBXAtomicValueListFieldFormatter {
    public let project: XcodeProject
    private let singlelineFormatter: PBXAtomicValueListFieldFormatterComponent
    private let multilineFormatter: PBXAtomicValueListFieldFormatterComponent
    public init(
        project: XcodeProject,
        singlelineFormatter: PBXAtomicValueListFieldFormatterComponent,
        multilineFormatter: PBXAtomicValueListFieldFormatterComponent
        ) {
        self.project = project
        self.singlelineFormatter = singlelineFormatter
        self.multilineFormatter = multilineFormatter
    }
    public func format(of info: PBXAtomicValueListFieldFormatterInfomation, for level: Int) -> String {
        let key = try! escape(with: info.key)

        if key == "isa" {
            fatalError("unexcepct isa: \(info.isa)")
        }
        
        let objectIds = info.value
        switch isMultiLine(info.isa) {
        case false:
            return singlelineFormatter.format(of: (key: key, objectIds: objectIds.map { $0.pbxValue() }), level: level)
        case true:
            return multilineFormatter.format(of: (key: key, objectIds: objectIds.map { $0.pbxValue() }), level: level)
        }
    }
}

public protocol PBXAtomicValueListFieldFormatterComponent: AutoMockable {
    func format(of info: (key: String, objectIds: [PBXObjectIDType]), level: Int) -> String
}

