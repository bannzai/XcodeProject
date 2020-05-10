//
//  BuildFileExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/25.
//

import Foundation

public protocol BuildFileExtractor {
    func extract(context: Context, fileName: String) -> PBX.BuildFile?
}

public struct BuildFileExtractorImpl: BuildFileExtractor {
    public init() { }
    public func extract(context: Context, fileName: String) -> PBX.BuildFile? {
        return context
            .objects
            .values
            .compactMap { $0 as? PBX.BuildFile }
            .first { $0.fileRef?.path == fileName }
    }
}
