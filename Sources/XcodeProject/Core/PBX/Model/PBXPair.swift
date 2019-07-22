//
//  PBXPair.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol PBXInterface { }

public typealias PBXRawKey = String
public typealias PBXAtomicRawValue = String
public typealias PBXPair = [String: PBXInterface]

extension PBXPair: PBXInterface {
    
}

extension Array: PBXInterface where Element == PBXInterface {
    
}

extension PBXAtomicRawValue: PBXInterface {
    
}

extension Int32: PBXInterface {
    
}

extension Int: PBXInterface {
    
}
