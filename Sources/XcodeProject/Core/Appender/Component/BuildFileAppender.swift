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
    private let buildFileMaker: BuildFileMaker
    private let resourceBuildPhaseAppender: BuildPhaseAppender
    private let sourceBuildPhaseAppender: BuildPhaseAppender
    public init(
        buildFileMaker: BuildFileMaker = BuildFileMakerImpl(),
        resourceBuildPhaseAppender: BuildPhaseAppender = ResourceBuildPhaseAppenderImpl(),
        sourceBuildPhaseAppender: BuildPhaseAppender = SourceBuildPhaseAppenderImpl()
        ) {
        self.buildFileMaker = buildFileMaker
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
        
        let buildFile = buildFileMaker.make(context: context, fileRefId: fileRefID)
        let lastKnownType = KnownFileExtension(fileName: fileName)
        switch lastKnownType.type {
        case .resourceFile, .text:
            resourceBuildPhaseAppender.append(context: context, buildFile: buildFile, target: target)
        case .sourceCode:
            sourceBuildPhaseAppender.append(context: context, buildFile: buildFile, target: target)
        case _:
            fatalError("Unexpected file format")
        }
        
        return buildFile
    }
}
