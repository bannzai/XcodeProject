//
//  PBXRawMapType.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public typealias PBXRawKeyType = String
public typealias PBXRawAnyValueType = Any
public typealias PBXRawMapType = [PBXRawKeyType: PBXRawAnyValueType]

// FIXME: For parsed pbx propertylist values, after all string raw value.
public typealias PBXRawAtomicValueType = String

public typealias PBXObjectIDType = PBXRawAtomicValueType
