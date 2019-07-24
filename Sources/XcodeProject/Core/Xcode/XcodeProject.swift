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
    
    private let parser: ContextParser
    private let hashIDGenerator: StringGenerator

    public init(
        parser: ContextParser,
        hashIDGenerator: StringGenerator
        ) {
        self.parser = parser
        self.hashIDGenerator = hashIDGenerator
        
        context = parser.context()
    }
}

// MARK: - Append
extension XcodeProject {
    public func appendFilePath(projectRootPath: String, filePath: String, targetName: String) {
        let groupPathNames = Array(filePath
            .components(separatedBy: "/")
            .filter { !$0.isEmpty }
            .dropLast()
        )
        
        let _ = GroupAppenderImpl(
            hashIDGenerator: PBXObjectHashIDGenerator(),
            groupExtractor: GroupExtractorImpl()
        )
        .append(context: context, childrenIDs: [], path: groupPathNames.joined(separator: "/"))
       
        let fileRef = FileReferenceAppenderImpl(
            hashIDGenerator: PBXObjectHashIDGenerator(),
            fileRefExtractor: FileRefExtractorImpl(groupExtractor: GroupExtractorImpl()),
            groupExtractor: GroupExtractorImpl()
        )
        .append(context: context, filePath: filePath)
        
        BuildFileAppenderImpl(
            hashIDGenerator: PBXObjectHashIDGenerator(),
            resourceBuildPhaseAppender: ResourceBuildPhaseAppenderImpl(hashIDGenerator: PBXObjectHashIDGenerator()),
            sourceBuildPhaseAppender: SourceBuildPhaseAppenderImpl(hashIDGenerator: PBXObjectHashIDGenerator())
        )
        .append(context: context, fileRefID: fileRef.id, targetName: targetName, fileName: fileRef.path!)
    }
}
