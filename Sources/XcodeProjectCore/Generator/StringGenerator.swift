//
//  RandomStringGenerator.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol StringGenerator: AutoMockable {
    func generate() -> String
}

public struct PBXObjectHashIDGenerator: StringGenerator {
    public init() { }
    public func generate() -> String {
        let all = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toArray().map { String($0) }
        var result: String = ""
        for _ in 0..<24 {
            result += all[Int(arc4random_uniform(UInt32(all.count)))]
        }
        return result
    }
}
