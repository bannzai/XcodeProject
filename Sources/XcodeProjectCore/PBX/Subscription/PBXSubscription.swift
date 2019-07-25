//
//  PBXSubscription.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/26.
//

import Foundation

extension Sequence where Element: PBX.Object {
    public subscript(id id: String) -> PBX.Object? {
        return self.filter { $0.id == id }.first
    }
}

