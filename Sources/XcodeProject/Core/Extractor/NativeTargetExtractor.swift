//
//  NativeTargetExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol NativeTargetExtractor {
    func extract(context: Context, targetName: String) -> PBX.NativeTarget?
}

public struct NativeTargetExtractorImpl: NativeTargetExtractor {
    public func extract(context: Context, targetName: String) -> PBX.NativeTarget? {
        return context
            .objects
            .values
            .compactMap { $0 as? PBX.NativeTarget }
            .first { $0.name == targetName}
    }
}
