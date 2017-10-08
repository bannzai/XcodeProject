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
