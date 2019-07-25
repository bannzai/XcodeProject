//
//  ResourcesBuildPhaseExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol ResourcesBuildPhaseExtractor: BuildPhaseExtractor, AutoMockable {
    func extract(context: Context, targetName: String) -> PBX.ResourcesBuildPhase?
}

public struct ResourcesBuildPhaseExtractorImpl: ResourcesBuildPhaseExtractor {
    public let targetExtractor: NativeTargetExtractor
    public init(
        targetExtractor: NativeTargetExtractor = NativeTargetExtractorImpl()
        ) {
        self.targetExtractor = targetExtractor
    }
}
