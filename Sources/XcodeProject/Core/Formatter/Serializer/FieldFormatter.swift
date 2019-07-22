//
//  FieldFormatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public typealias FieldFormatterInfomation = (key: PBXRawKeyType, value: [PBXRawAtomicValueType], isa: ObjectType)
public protocol FieldFormatter: SerializeFormatter {
    func format(of info: FieldFormatterInfomation, for level: Int) -> String
}


