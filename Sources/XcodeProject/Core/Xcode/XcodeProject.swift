//
//
//  XcodeProject.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/20.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

public class XcodeProject {
    let context: Context
    
    public var rootID: String {
        return context.allPBX["rootObject"] as! String
    }
    
    private let fileReferenceAppender: FileReferenceAppender
    private let groupAppender: GroupAppender
    private let bulidFileAppender: BuildFileAppender
    public init(
        xcodeprojectURL: URL,
        parser: ContextParser = PBXProjectContextParser(),
        fileReferenceAppender: FileReferenceAppender = FileReferenceAppenderImpl(
            hashIDGenerator: PBXObjectHashIDGenerator(),
            fileRefExtractor: FileRefExtractorImpl(groupExtractor: GroupExtractorImpl()),
            groupExtractor: GroupExtractorImpl()
        ),
        groupAppender: GroupAppender = GroupAppenderImpl(
            hashIDGenerator: PBXObjectHashIDGenerator(),
            groupExtractor: GroupExtractorImpl()
        ),
        bulidFileAppender: BuildFileAppenderImpl = BuildFileAppenderImpl(
            hashIDGenerator: PBXObjectHashIDGenerator(),
            resourceBuildPhaseAppender: ResourceBuildPhaseAppenderImpl(hashIDGenerator: PBXObjectHashIDGenerator()),
            sourceBuildPhaseAppender: SourceBuildPhaseAppenderImpl(hashIDGenerator: PBXObjectHashIDGenerator())
        ),
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator()
        ) throws {
        context = try parser.parse(xcodeprojectUrl: xcodeprojectURL)
        self.fileReferenceAppender = fileReferenceAppender
        self.groupAppender = groupAppender
        self.bulidFileAppender = bulidFileAppender
    }
}

// MARK: - Append
extension XcodeProject {
    public func append(filePath: PBXRawPathType, to projectRootPath: PBXRawPathType, targetName: String) {
        let groupPathNames = Array(filePath
            .components(separatedBy: "/")
            .filter { !$0.isEmpty }
            .dropLast()
        )
        
        if !groupPathNames.isEmpty {
            let _ = groupAppender.append(context: context, childrenIDs: [], path: groupPathNames.joined(separator: "/"))
        }
        let fileRef = fileReferenceAppender.append(context: context, filePath: filePath)
        bulidFileAppender.append(context: context, fileRefID: fileRef.id, targetName: targetName, fileName: fileRef.path!)
    }
}
