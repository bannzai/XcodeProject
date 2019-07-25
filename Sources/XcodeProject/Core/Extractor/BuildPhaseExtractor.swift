//
//  SourcesBuildPhaseExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol BuildPhaseExtractor {
    associatedtype BuildPhase = PBX.BuildPhase
    func extract(context: Context, targetName: String) -> BuildPhase?
}

extension BuildPhaseExtractor {
    public func extract(context: Context, targetName: String) -> BuildPhase? {
        return context
            .objects
            .values
            .compactMap { $0 as? PBX.NativeTarget }
            .first { $0.name == targetName }?
            .buildPhases
            .compactMap { $0 as? BuildPhase }
            .first
    }
}
