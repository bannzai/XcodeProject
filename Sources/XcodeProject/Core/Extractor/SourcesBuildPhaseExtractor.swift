//
//  SourcesBuildPhaseExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol BuildPhaseExtractor {
    func extract<T: PBX.BuildPhase>(context: Context, targetName: String) -> T?
}

public struct BuildPhaseExtractorImpl: BuildPhaseExtractor {
    public func extract<T: PBX.BuildPhase>(context: Context, targetName: String) -> T? {
        return context
            .objects
            .values
            .compactMap { $0 as? PBX.NativeTarget }
            .first { $0.name == targetName }?
            .buildPhases
            .compactMap { $0 as? T }
            .first
    }
}
