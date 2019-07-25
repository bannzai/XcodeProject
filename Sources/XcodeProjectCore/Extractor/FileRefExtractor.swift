//
//  FileRefExtractor.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public protocol FileRefExtractor {
    func extract(context: Context, groupPath: PBXRawPathType, fileName: String) -> PBX.FileReference?
}

public struct FileRefExtractorImpl: FileRefExtractor {
    private let groupExtractor: GroupExtractor
    public init(
        groupExtractor: GroupExtractor = GroupExtractorImpl()
        ) {
        self.groupExtractor = groupExtractor
    }
    public func extract(context: Context, groupPath: PBXRawPathType, fileName: String) -> PBX.FileReference? {
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
}
