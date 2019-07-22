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

public protocol PBXRawAtomicValuable {
    func pbxValue() -> String
}
extension String: PBXRawAtomicValuable {
    public func pbxValue() -> String {
        return self
    }
}
extension Int: PBXRawAtomicValuable {
    public func pbxValue() -> String {
        return "\(self)"
    }
}
extension Int32: PBXRawAtomicValuable {
    public func pbxValue() -> String {
        return "\(self)"
    }
}
public typealias PBXRawAtomicValueType = PBXRawAtomicValuable

public typealias PBXObjectIDType = String
