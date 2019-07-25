//
//  SourcesBuildPhaseExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol SourcesBuildPhaseExtractor {
    func extract(context: Context, targetName: String) -> PBX.SourcesBuildPhase?
}

public struct SourcesBuildPhaseExtractorImpl: SourcesBuildPhaseExtractor {
    public func extract(context: Context, targetName: String) -> PBX.SourcesBuildPhase? {
        return context
            .objects
            .values
            .compactMap { $0 as? PBX.NativeTarget }
            .first { $0.name == targetName }?
            .buildPhases
            .compactMap { $0 as? PBX.SourcesBuildPhase }
            .first
    }
}
