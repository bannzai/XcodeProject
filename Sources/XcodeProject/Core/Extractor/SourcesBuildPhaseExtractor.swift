//
//  SourcesBuildPhaseExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol SourcesBuildPhaseExtractor: BuildPhaseExtractor, AutoMockable {
    func extract(context: Context, targetName: String) -> PBX.SourcesBuildPhase?
}

public struct SourcesBuildPhaseExtractorImpl: SourcesBuildPhaseExtractor {
    public init() { }
}
