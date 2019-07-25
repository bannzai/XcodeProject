//
//  BuildFileMaker.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol BuildFileMaker {
    func make(context: Context, fileRefId: String) -> PBX.BuildFile
}

public struct BuildFileMakerImpl: BuildFileMaker {
    private let hashIDGenerator: StringGenerator
    public init(
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator()
        ) {
        self.hashIDGenerator = hashIDGenerator
    }
    
    public func make(context: Context, fileRefId: String) -> PBX.BuildFile {
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
