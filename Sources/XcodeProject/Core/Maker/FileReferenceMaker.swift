//
//  FileReferenceMaker.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol FileReferenceMaker {
    func make(context: Context, fileName: String) -> PBX.FileReference
}

public struct FileReferenceMakerImpl: FileReferenceMaker {
    private let hashIDGenerator: StringGenerator
    public init(
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator()
        ) {
        self.hashIDGenerator = hashIDGenerator
    }
    
    public func make(context: Context, fileName: String) -> PBX.FileReference {
        let isa = ObjectType.PBXFileReference
        let fileRefId = hashIDGenerator.generate()
        
        let pair: PBXRawMapType = [
            "isa": isa.rawValue,
            "fileEncoding": 4,
            "lastKnownFileType": LastKnownFile(fileName: fileName).value,
            "path": fileName,
            "sourceTree": "<group>"
        ]
        
        let fileRef = PBX.FileReference(
            id: fileRefId,
            dictionary: pair,
            isa: isa.rawValue,
            context: context
        )

        return fileRef
    }

}
