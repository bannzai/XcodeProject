//
//  ArrayExtension.swift
//  XcodeProject
//
//  Created by Yudai.Hirose on 2017/10/08.
//

import Foundation

extension Array {
    func ofType<T>(_ type: T.Type) -> [T] {
        return self.flatMap { $0 as? T }
    }
}

extension Array {
    func groupBy<GroupKey: Hashable>(for keyExtractor: (Element) -> GroupKey) -> [GroupKey: [Element]] {
        return reduce([GroupKey: [Element]]()) { result, value in
            let key = keyExtractor(value)
            let groupedValues = result[key]
            
            var dictionary = result
            dictionary[key] = (groupedValues ?? []) + [value]
            return dictionary
        }
    }
}
