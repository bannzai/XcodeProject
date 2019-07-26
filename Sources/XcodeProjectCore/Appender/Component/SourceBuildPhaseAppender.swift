//
//  SourceBuildPhaseAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public struct SourceBuildPhaseAppenderImpl: BuildPhaseAppender {
    private let maker: BuildPhaseMaker
    private let extractor: SourcesBuildPhaseExtractor
    public init(
        maker: BuildPhaseMaker = BuildPhaseMakerImpl(),
        extractor: SourcesBuildPhaseExtractor = SourcesBuildPhaseExtractorImpl()
        ) {
        self.maker = maker
        self.extractor = extractor
    }
    
    @discardableResult public func append(context: Context, targetName: String) -> PBX.BuildPhase {
        if let sourcesBuildPhase = extractor.extract(context: context, targetName: targetName) {
            return sourcesBuildPhase
        }
        
        let sourceBuildPhase = maker.makeSourcesBuildPhase(context: context)
        context.objects[sourceBuildPhase.id] = sourceBuildPhase
        return sourceBuildPhase
    }
}
