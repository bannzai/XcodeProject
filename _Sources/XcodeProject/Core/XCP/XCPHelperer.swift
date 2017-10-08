//
//  XCPHelperer.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/12/23.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

func assertionMessage(
    with function: String = #function,
         file: String = #file,
         line: Int = #line,
         description: String ...
    ) -> String {
    
    return [
        "function: \(function)",
        "file: \(file)",
        "line: \(line)",
        "description: \(description)",
        ].joined(separator: "\n")
}

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

extension Collection {
    func toArray() -> Array<Element> {
        return Array(self)
    }
}
