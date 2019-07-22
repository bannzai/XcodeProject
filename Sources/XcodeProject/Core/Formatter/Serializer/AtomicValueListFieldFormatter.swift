//
//  AtomicValueListFieldFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public struct AtomicValueListFieldFormatter: FieldFormatter {
    public let project: XcodeProject
    private let singlelineFormatter: AtomicValueListFieldFormatterComponent
    private let multilineFormatter: AtomicValueListFieldFormatterComponent
    public init(
        project: XcodeProject,
        singlelineFormatter: AtomicValueListFieldFormatterComponent,
        multilineFormatter: AtomicValueListFieldFormatterComponent
        ) {
        self.project = project
        self.singlelineFormatter = singlelineFormatter
        self.multilineFormatter = multilineFormatter
    }
    public func format(of info: FieldFormatterInfomation, for level: Int) -> String {
        let key = try! escape(with: info.key)

        if key == "isa" {
            // skip
            fatalError("unexcepct isa: \(info.isa)")
        }
        
        let objectIds = info.value
        switch isMultiLine(info.isa) {
        case false:
            return singlelineFormatter.format(of: (key: key, objectIds: objectIds), level: level)
        case true:
            return multilineFormatter.format(of: (key: key, objectIds: objectIds), level: level)
        }
    }
}

public protocol AtomicValueListFieldFormatterComponent: SerializeFormatter {
    func format(of info: (key: String, objectIds: [PBXObjectIDType]), level: Int) -> String
}

