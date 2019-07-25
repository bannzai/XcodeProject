//
//  FileReferenceAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/23.
//

import Foundation

public protocol FileReferenceAppender {
    @discardableResult func append(context: Context, filePath: PBXRawPathType) -> PBX.FileReference
}

public struct FileReferenceAppenderImpl: FileReferenceAppender {
    private let fileReferenceMaker: FileReferenceMaker
    private let fileRefExtractor: FileRefExtractor
    private let groupExtractor: GroupExtractor
    public init(
        fileReferenceMaker: FileReferenceMaker = FileReferenceMakerImpl(),
        fileRefExtractor: FileRefExtractor = FileRefExtractorImpl(),
        groupExtractor: GroupExtractor = GroupExtractorImpl()
        ) {
        self.fileReferenceMaker = fileReferenceMaker
        self.fileRefExtractor = fileRefExtractor
        self.groupExtractor = groupExtractor
    }
    
    @discardableResult public func append(context: Context, filePath: PBXRawPathType) -> PBX.FileReference {
        let pathComponent = filePath.components(separatedBy: "/")
        guard let fileName = pathComponent.last else {
            fatalError()
        }

        let groupPath = pathComponent.dropLast().joined(separator: "/")
        if let reference = fileRefExtractor.extract(context: context, groupPath: groupPath, fileName: fileName) {
            return reference
        }
        
        let fileRef = fileReferenceMaker.make(context: context, fileName: fileName)
        context.objects[fileRef.id] = fileRef

        appendToGroupIfExists: do {
            if let lastGroup = groupExtractor.extract(context: context, path: groupPath) {
                if let reference = context.objects[lastGroup.id] as? PBX.Group {
                    lastGroup.children.append(reference)
                }
            }
        }
        
        return fileRef
    }
}

