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
        return context.rootID
    }
    
    public var objects: [String: PBX.Object] {
        return context.objects
    }
    
    public var mainGroup: PBX.Group {
        return context.mainGroup
    }
    
    private let fileReferenceAppender: FileReferenceAppender
    private let groupAppender: GroupAppender
    private let bulidFileAppender: BuildFileAppender
    private let fileWriter: Writer
    public init(
        xcodeprojectURL: URL,
        parser: ContextParser = PBXProjectContextParser(),
        fileWriter: Writer = FileWriter(),
        fileReferenceAppender: FileReferenceAppender = FileReferenceAppenderImpl(),
        groupAppender: GroupAppender = GroupAppenderImpl(),
        bulidFileAppender: BuildFileAppenderImpl = BuildFileAppenderImpl(),
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator()
        ) throws {
        context = try parser.parse(xcodeprojectUrl: xcodeprojectURL)
        self.fileWriter = fileWriter
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

// MARK: - Write
extension XcodeProject {
    public func write() throws {
       try fileWriter.write(xcodeProject: self)
    }
}
