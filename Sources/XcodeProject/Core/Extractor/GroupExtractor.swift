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
    public func extract(context: Context, path: String) -> PBX.Group? {
        return context
            .objects
            .values
            .compactMap { $0 as? PBX.Group }
            .filter { $0.fullPath == path }
            .last
    }
}
