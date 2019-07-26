//
//  SourcesBuildPhaseExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol BuildPhaseExtractor {
    var targetExtractor: NativeTargetExtractor { get }
    func extract<T: PBX.BuildPhase>(context: Context, targetName: String) -> T?
}

extension BuildPhaseExtractor {
    public func extract<T: PBX.BuildPhase>(context: Context, targetName: String) -> T? {
        return targetExtractor
            .extract(context: context, targetName: targetName)?
            .buildPhases
            .compactMap { $0 as? T }
            .first
    }
}
