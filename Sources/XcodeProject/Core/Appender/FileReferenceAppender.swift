//
//  FileReferenceAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/23.
//

import Foundation

public protocol FileReferenceAppender {
    func append(context: Context, fileName: String, and fileRefId: String)
}

public struct FileReferenceAppenderImpl: FileReferenceAppender {
    public init() { }
    
    public func append(context: Context, fileName: String, and fileRefId: String) {
        let fileRef: PBX.FileReference
        
        let isa = ObjectType.PBXFileReference.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "fileEncoding": 4,
            "lastKnownFileType": LastKnownFile(fileName: fileName).value,
            "path": fileName,
            "sourceTree": "<group>"
        ]
        
        fileRef = PBX.FileReference(
            id: fileRefId,
            dictionary: pair,
            isa: isa,
            context: context
        )
        
        context.objects[fileRefId] = fileRef
    }
}

