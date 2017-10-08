//
//  DictionaryExtension.swift
//  XcodeProjectPackageDescription
//
//  Created by Yudai.Hirose on 2017/10/08.
//

import Foundation

// MARK: - Operator
func += <K, V> (left: inout [K: V], right: [K: V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension Dictionary {
    typealias Group = [Key: [Value]]
    func groupBy() -> [Group] {
        return reduce([Group]()) { result, pair in
            let groupedValues = result.flatMap { $0[pair.key] }.first
            let appendGroup: Group
            
            switch groupedValues {
            case .none:
                appendGroup = [pair.key: [pair.value]]
            case .some(let groupedValues):
                appendGroup = [pair.key: groupedValues + [pair.value]]
            }
            return result + [appendGroup]
        }
    }
}

