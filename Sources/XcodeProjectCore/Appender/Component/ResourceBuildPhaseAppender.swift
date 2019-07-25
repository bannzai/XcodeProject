//
//  ResourceBuildPhaseAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public struct ResourceBuildPhaseAppenderImpl: BuildPhaseAppender {
    private let maker: BuildPhaseMaker
    private let extractor: ResourcesBuildPhaseExtractor
    public init(
        maker: BuildPhaseMaker = BuildPhaseMakerImpl(),
        extractor: ResourcesBuildPhaseExtractor = ResourcesBuildPhaseExtractorImpl()
        ) {
        self.maker = maker
        self.extractor = extractor
    }
    
    @discardableResult public func append(context: Context, targetName: String) -> PBX.BuildPhase {
        if let buildPhase = extractor.extract(context: context, targetName: targetName) {
            return buildPhase
        }
        
        let buildPhase = maker.makeResourcesBuildPhase(context: context)
        context.objects[buildPhase.id] = buildPhase
        return buildPhase
    }
}
