//
//  BuildPhaseMaker.swift
//  XcodeProjectCore
//
//  Created by Yudai Hirose on 2019/07/26.
//

import Foundation

public protocol BuildPhaseMaker {
    func makeSourcesBuildPhase(context: Context) -> PBX.SourcesBuildPhase
    func makeResourcesBuildPhase(context: Context) -> PBX.ResourcesBuildPhase
}

public struct BuildPhaseMakerImpl: BuildPhaseMaker {
    private let hashIDGenerator: StringGenerator
    public init(
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator()
        ) {
        self.hashIDGenerator = hashIDGenerator
    }
    
    public func makeSourcesBuildPhase(context: Context) -> PBX.SourcesBuildPhase {
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
        
        return sourceBuildPhase
    }
    
    public func makeResourcesBuildPhase(context: Context) -> PBX.ResourcesBuildPhase {
        let isa = ObjectType.PBXResourcesBuildPhase.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "buildActionMask": Int32.max,
            "files": [],
            "runOnlyForDeploymentPostprocessing": 0
        ]
        
        let buildPhaseId = hashIDGenerator.generate()
        let buildPhase = PBX.ResourcesBuildPhase(
            id: buildPhaseId,
            dictionary: pair,
            isa: isa,
            context: context
        )

        return buildPhase
    }
}
