//
//  ResourceBuildPhaseAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public struct ResourceBuildPhaseAppenderImpl: BuildPhaseAppender {
    private let hashIDGenerator: StringGenerator
    private let extractor: ResourcesBuildPhaseExtractor
    public init(
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator(),
        extractor: ResourcesBuildPhaseExtractor = ResourcesBuildPhaseExtractorImpl()
        ) {
        self.hashIDGenerator = hashIDGenerator
        self.extractor = extractor
    }
    
    @discardableResult public func append(context: Context, buildFile: PBX.BuildFile, target: PBX.NativeTarget) -> PBX.BuildPhase {
        let buildPhase = extractor.extract(context: context, targetName: target.name)
        switch buildPhase {
        case .some(let buildPhase):
            buildPhase.files.append(buildFile)
            return buildPhase
        case .none:
            let isa = ObjectType.PBXResourcesBuildPhase.rawValue
            let pair: PBXRawMapType = [
                "isa": isa,
                "buildActionMask": Int32.max,
                "files": [
                    buildFile.id
                ],
                "runOnlyForDeploymentPostprocessing": 0
            ]
            
            let buildPhaseId = hashIDGenerator.generate()
            let buildPhase = PBX.ResourcesBuildPhase(
                id: buildPhaseId,
                dictionary: pair,
                isa: isa,
                context: context
            )
            context.objects[buildPhaseId] = buildPhase
            return buildPhase
        }
    }
}
