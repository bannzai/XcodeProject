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
    private let hashIDGenerator: StringGenerator
    private let groupExtractor: GroupExtractor
    public init(
        hashIDGenerator: StringGenerator,
        groupExtractor: GroupExtractor
        ) {
        self.hashIDGenerator = hashIDGenerator
        self.groupExtractor = groupExtractor
    }
    
    private func extractFielRef(context: Context, groupPath: PBXRawPathType, fileName: String) -> PBX.FileReference? {
        switch groupExtractor.extract(context: context, path: groupPath) {
        case .some(let group):
            guard let fileReference = group.children.compactMap ({ $0 as? PBX.FileReference }).filter ({ $0.path == fileName }).first else {
                return nil
            }
            return fileReference
        case .none:
            return nil
        }
    }
    
    @discardableResult public func append(context: Context, filePath: PBXRawPathType) -> PBX.FileReference {
        let pathComponent = filePath.components(separatedBy: "/")
        guard let fileName = pathComponent.last else {
            fatalError()
        }

        let groupPath = pathComponent.dropLast().joined(separator: "/")
        if let reference = extractFielRef(context: context, groupPath: groupPath, fileName: fileName) {
            return reference
        }
        
        let fileRefId = hashIDGenerator.generate()
        
        let isa = ObjectType.PBXFileReference.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "fileEncoding": 4,
            "lastKnownFileType": LastKnownFile(fileName: fileName).value,
            "path": fileName,
            "sourceTree": "<group>"
        ]
        
        let fileRef = PBX.FileReference(
            id: fileRefId,
            dictionary: pair,
            isa: isa,
            context: context
        )

        context.objects[fileRefId] = fileRef
        
        appendGroupIfExists: do {
            if let lastGroup = groupExtractor.extract(context: context, path: groupPath) {
                if let reference = context.objects[lastGroup.id] as? PBX.Group {
                    lastGroup.children.append(reference)
                }
            }
        }
        
        return fileRef
    }
}

