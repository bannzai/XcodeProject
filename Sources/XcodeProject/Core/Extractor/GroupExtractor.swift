//
//  GroupExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public protocol GroupExtractor {
    func extract(context: Context, path: String) -> PBX.Group?
}

public struct GroupExtractorImpl: GroupExtractor {
    public init() { }
    
    public func extract(context: Context, path: String) -> PBX.Group? {
        switch path.isEmpty {
        case true:
            return context
                .objects
                .values
                .compactMap { $0 as? PBX.Group }
                .filter { $0.fullPath.isEmpty }
                .filter { $0.name == nil }
                .last
        case false:
            return context
                .objects
                .values
                .compactMap { $0 as? PBX.Group }
                .filter { $0.fullPath == path }
                .last
        }
    }
}
