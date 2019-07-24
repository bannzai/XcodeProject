//
//  BuildPhaseAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public protocol BuildPhaseAppender {
    @discardableResult func append(
        context: Context,
        fileRefID: PBXObjectIDType,
        targetName: String,
        fileName: String
    ) -> PBX.BuildPhase
}

public protocol EachBuildPhaseAppender {
    @discardableResult func append(context: Context, buildFile: PBX.BuildFile, target: PBX.NativeTarget) -> PBX.BuildPhase
}

public struct BuildPhaseAppenderImpl: BuildPhaseAppender {
    private let hashIDGenerator: StringGenerator
    private let resourceBuildPhaseAppender: EachBuildPhaseAppender
    private let sourceBuildPhaseAppender: EachBuildPhaseAppender
    public init(
        hashIDGenerator: StringGenerator,
        resourceBuildPhaseAppender: EachBuildPhaseAppender,
        sourceBuildPhaseAppender: EachBuildPhaseAppender
        ) {
        self.hashIDGenerator = hashIDGenerator
        self.resourceBuildPhaseAppender = resourceBuildPhaseAppender
        self.sourceBuildPhaseAppender = sourceBuildPhaseAppender
    }
    
    @discardableResult public func append(
        context: Context,
        fileRefID: PBXObjectIDType,
        targetName: String,
        fileName: String
        ) -> PBX.BuildPhase {
        guard let target = context
            .objects
            .values
            .compactMap ({ $0 as? PBX.NativeTarget })
            .filter ({ $0.name == targetName })
            .first
            else {
                fatalError(assertionMessage(description: "Unexpected target name \(targetName)"))
        }
        
        let buildFile = makeBuildFile(context: context, fileRefId: fileRefID)
        let lastKnownType = LastKnownFile(fileName: fileName)
        switch lastKnownType.type {
        case .resourceFile, .markdown, .text:
            return resourceBuildPhaseAppender.append(context: context, buildFile: buildFile, target: target)
        case .sourceCode:
            return sourceBuildPhaseAppender.append(context: context, buildFile: buildFile, target: target)
        }
    }
    
    private func makeBuildFile(context: Context, fileRefId: String) -> PBX.BuildFile {
        let isa = ObjectType.PBXBuildFile.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "fileRef": fileRefId,
        ]
        
        let buildFileId = hashIDGenerator.generate()
        let buildFile = PBX.BuildFile(
            id: buildFileId,
            dictionary: pair,
            isa: isa,
            context: context
        )
        context.objects[buildFileId] = buildFile
        
        return buildFile
    }
}
