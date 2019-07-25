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
    private let resourceBuildPhaseAppender: BuildPhaseAppender
    private let sourceBuildPhaseAppender: BuildPhaseAppender
    public init(
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator(),
        resourceBuildPhaseAppender: BuildPhaseAppender = ResourceBuildPhaseAppenderImpl(),
        sourceBuildPhaseAppender: BuildPhaseAppender = SourceBuildPhaseAppenderImpl()
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
            resourceBuildPhaseAppender.append(context: context, buildFile: buildFile, target: target)
        case .sourceCode:
            sourceBuildPhaseAppender.append(context: context, buildFile: buildFile, target: target)
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
