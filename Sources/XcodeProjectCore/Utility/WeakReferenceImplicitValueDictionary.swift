//
//  WeakReferenceImplicitValueDictionary.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/26.
//

import Foundation

public struct WeakDictionaryReference<Value: AnyObject> {
    private weak var referencedValue: Value?
    
    init(value: Value) {
        referencedValue = value
    }
    
    public var value: Value? {
        return referencedValue
    }
}

public struct WeakDictionary<Key: Hashable, Value: AnyObject>: ExpressibleByDictionaryLiteral {
    private var dictionary: [Key: WeakDictionaryReference<Value>]
    
    public var values: [Value] {
        return dictionary.values.compactMap { $0.value }
    }

    public init(dictionaryLiteral elements: (Key, Value)...) {
        dictionary = [:]
        for element in elements {
            dictionary[element.0] = WeakDictionaryReference(value: element.1)
        }
    }
}

extension WeakDictionary: Collection {

    public typealias Index = DictionaryIndex<Key, WeakDictionaryReference<Value>>
    
    public var startIndex: Dictionary<Key, WeakDictionaryReference<Value>>.Index {
        return dictionary.startIndex
    }
    
    public var endIndex: Dictionary<Key, WeakDictionaryReference<Value>>.Index {
        return dictionary.endIndex
    }
    

    public func index(after i: Dictionary<Key, WeakDictionaryReference<Value>>.Index) -> Dictionary<Key, WeakDictionaryReference<Value>>.Index {
        return dictionary.index(after: i)
    }
    
    public subscript(position: Index) -> (key: Key, value: WeakDictionaryReference<Value>) {
        return dictionary[position]
    }

    public subscript(key: Key) -> Value? {
        get {
            return dictionary[key]?.value
        }
        
        set {
            switch newValue {
            case .none:
                dictionary[key] = nil
            case .some(let value):
                dictionary[key] = WeakDictionaryReference<Value>(value: value)
            }
        }
    }
}
