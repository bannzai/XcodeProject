//
//  SourceBuildPhaseAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public struct SourceBuildPhaseAppenderImpl: EachBuildPhaseAppender {
    private let hashIDGenerator: StringGenerator
    public init(
        hashIDGenerator: StringGenerator
        ) {
        self.hashIDGenerator = hashIDGenerator
    }
    
    public func append(context: Context, buildFile: PBX.BuildFile, target: PBX.NativeTarget) {
        let sourcesBuildPhase = target.buildPhases.compactMap { $0 as? PBX.SourcesBuildPhase }.first
        guard sourcesBuildPhase == nil else {
            // already exists
            sourcesBuildPhase?.files.append(buildFile)
            return
        }
        
        let isa = ObjectType.PBXSourcesBuildPhase.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "buildActionMask": Int32.max,
            "files": [
                buildFile.id
            ],
            "runOnlyForDeploymentPostprocessing": 0
        ]
        
        let buildPhaseId = hashIDGenerator.generate()
        context.objects[buildPhaseId] = PBX.SourcesBuildPhase(
            id: buildPhaseId,
            dictionary: pair,
            isa: isa,
            context: context
        )
    }
}
