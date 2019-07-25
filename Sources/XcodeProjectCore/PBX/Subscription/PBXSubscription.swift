//
//  PBXSubscription.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/26.
//

import Foundation

extension Sequence where Element: PBX.Object {
    public subscript(id id: String) -> Element? {
        return filter { $0.id == id }.first
    }
}

extension Sequence where Element: PBX.Reference {
    public subscript(name name: String) -> Element? {
        return filter { $0.name == name }.first
    }
    public subscript(path path: String) -> Element? {
        return filter { $0.path == path }.first
    }
    public subscript(nameOrPath str: String) -> Element? {
        return filter { ($0.name ?? $0.path) ==  str }.first
    }
}

extension Sequence where Element: PBX.Target {
    public subscript(name name: String) -> Element? {
        return filter { $0.name == name }.first
    }
}

extension Sequence where Element: PBX.Group {
    public subscript(fullPath fullPath: String) -> Element? {
        return filter { $0.fullPath == fullPath }.first
    }
}
