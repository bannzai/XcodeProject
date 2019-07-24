//
//  ResourceBuildPhaseAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public struct ResourceBuildPhaseAppenderImpl: EachBuildPhaseAppender {
    private let hashIDGenerator: StringGenerator
    public init(
        hashIDGenerator: StringGenerator
        ) {
        self.hashIDGenerator = hashIDGenerator
    }
    
    public func append(context: Context, buildFile: PBX.BuildFile, target: PBX.NativeTarget) {
        let builPhase = target.buildPhases.compactMap { $0 as? PBX.ResourcesBuildPhase }.first
        guard builPhase == nil else {
            // already exists
            builPhase?.files.append(buildFile)
            return
        }
        
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
        context.objects[buildPhaseId] = PBX.ResourcesBuildPhase(
            id: buildPhaseId,
            dictionary: pair,
            isa: isa,
            context: context
        )
    }
}
