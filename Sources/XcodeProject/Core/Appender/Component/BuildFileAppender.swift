//
//  BuildPhaseAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public protocol BuildFileAppender {
    @discardableResult func append(
        context: Context,
        fileRefID: PBXObjectIDType,
        targetName: String,
        fileName: String
        ) -> PBX.BuildFile
}

public struct BuildFileAppenderImpl: BuildFileAppender {
    private let hashIDGenerator: StringGenerator
    private let resourceBuildFileAppender: BuildPhaseAppender
    private let sourceBuildFileAppender: BuildPhaseAppender
    public init(
        hashIDGenerator: StringGenerator,
        resourceBuildFileAppender: BuildPhaseAppender,
        sourceBuildFileAppender: BuildPhaseAppender
        ) {
        self.hashIDGenerator = hashIDGenerator
        self.resourceBuildFileAppender = resourceBuildFileAppender
        self.sourceBuildFileAppender = sourceBuildFileAppender
    }
    
    @discardableResult public func append(
        context: Context,
        fileRefID: PBXObjectIDType,
        targetName: String,
        fileName: String
        ) -> PBX.BuildFile {
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
            resourceBuildFileAppender.append(context: context, buildFile: buildFile, target: target)
        case .sourceCode:
            sourceBuildFileAppender.append(context: context, buildFile: buildFile, target: target)
        }
        
        return buildFile
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
