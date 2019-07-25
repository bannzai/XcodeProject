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
    private let extractor: BuildFileExtractor
    private let resourcesBuildPhaseExtractor: ResourcesBuildPhaseExtractor
    private let sourcesBuildPhaseExtractor: SourcesBuildPhaseExtractor
    public init(
        buildFileMaker: BuildFileMaker = BuildFileMakerImpl(),
        extractor: BuildFileExtractor = BuildFileExtractorImpl(),
        resourcesBuildPhaseExtractor: ResourcesBuildPhaseExtractor = ResourcesBuildPhaseExtractorImpl(),
        sourcesBuildPhaseExtractor: SourcesBuildPhaseExtractor = SourcesBuildPhaseExtractorImpl()
        ) {
        self.buildFileMaker = buildFileMaker
        self.extractor = extractor
        self.resourcesBuildPhaseExtractor = resourcesBuildPhaseExtractor
        self.sourcesBuildPhaseExtractor = sourcesBuildPhaseExtractor
    }
    
    @discardableResult public func append(
        context: Context,
        fileRefID: PBXObjectIDType,
        targetName: String,
        fileName: String
        ) -> PBX.BuildFile {
        if let buildFile = extractor.extract(context: context, fileName: fileName) {
            return buildFile
        }
        
        let buildFile = buildFileMaker.make(context: context, fileRefId: fileRefID)
        
        appendToBuildPhase: do {
            let lastKnownType = KnownFileExtension(fileName: fileName)
            switch lastKnownType.type {
            case .resourceFile, .text:
                if let buildPhase = resourcesBuildPhaseExtractor.extract(context: context, targetName: targetName) {
                    buildPhase.files.append(buildFile)
                }
            case .sourceCode:
                if let buildPhase = sourcesBuildPhaseExtractor.extract(context: context, targetName: targetName) {
                    buildPhase.files.append(buildFile)
                }
            case _:
                fatalError("Unexpected file format")
            }
        }
        
        return buildFile
        
    }
}
