//
//  PBXRawType.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol PBXInterface { }

public typealias PBXRawKey = String
public typealias PBXAtomicRawValue = String
public typealias PBXRawType = [String: PBXInterface]

extension PBXRawType: PBXInterface {
    
}

extension Array: PBXInterface where Element == PBXInterface {
    
}

extension PBXAtomicRawValue: PBXInterface {
    
}

extension Int32: PBXInterface {
    
}

extension Int: PBXInterface {
    
}
