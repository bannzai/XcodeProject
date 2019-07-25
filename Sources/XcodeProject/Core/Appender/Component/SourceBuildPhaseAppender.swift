//
//  SourceBuildPhaseAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public struct SourceBuildPhaseAppenderImpl: BuildPhaseAppender {
    private let hashIDGenerator: StringGenerator
    private let extractor: SourcesBuildPhaseExtractor
    public init(
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator(),
        extractor: SourcesBuildPhaseExtractor = SourcesBuildPhaseExtractorImpl()
        ) {
        self.hashIDGenerator = hashIDGenerator
        self.extractor = extractor
    }
    
    @discardableResult public func append(context: Context, target: PBX.NativeTarget) -> PBX.BuildPhase {
        if let sourcesBuildPhase = extractor.extract(context: context, targetName: target.name) {
            return sourcesBuildPhase
        }
        
        let isa = ObjectType.PBXSourcesBuildPhase.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "buildActionMask": Int32.max,
            "files": [],
            "runOnlyForDeploymentPostprocessing": 0
        ]
        
        let buildPhaseId = hashIDGenerator.generate()
        let sourceBuildPhase = PBX.SourcesBuildPhase(
            id: buildPhaseId,
            dictionary: pair,
            isa: isa,
            context: context
        )
        context.objects[buildPhaseId] = sourceBuildPhase
        return sourceBuildPhase
    }
}
