//
//  AtomicValueListFieldFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public struct AtomicValueListFieldFormatter: FieldFormatter {
    public let project: XcodeProject
    public init(project: XcodeProject) {
        self.project = project
    }
    public func format(of info: FieldFormatterInfomation, for level: Int) -> String {
        fatalError()
    }
}

public protocol AtomicValueListFieldFormatterComponent: SerializeFormatter {
    func format(of info: (key: String, objectIds: [PBXObjectIDType]), level: Int) -> String
}

