//
//  GroupAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/23.
//

import Foundation

public protocol GroupAppender {
    @discardableResult func append(
        context: Context,
        childrenIDs: [PBXObjectIDType],
        path: PBXRawPathType
    ) -> PBX.Group
}

public struct GroupAppenderImpl: GroupAppender {
    private let maker: GroupMaker
    private let extractor: GroupExtractor
    public init(
        maker: GroupMaker = GroupMakerImpl(),
        extractor: GroupExtractor = GroupExtractorImpl()
        ) {
        self.maker = maker
        self.extractor = extractor
    }
    
    @discardableResult public func append(
        context: Context,
        childrenIDs: [PBXObjectIDType],
        path: PBXRawPathType
        ) -> PBX.Group {
        if path.isEmpty {
            fatalError("Unexpected for path is empty")
        }
        
        if let alreadyExistsGroup = extractor.extract(context: context, path: path) {
            return alreadyExistsGroup
        }

        let groupPathNames = path.components(separatedBy: "/")
        guard let pathName = groupPathNames.last else {
            fatalError("unexpected not exists last value")
        }
        
        let group = maker.make(context: context, childrenIds: childrenIDs, pathName: pathName)
        context.objects[group.id] = group
        

        let nextPathComponent = groupPathNames.dropLast().joined(separator: "/")
        // FIXME: Integrate reset Group full paths
        context.createGroupPath(with: group, parentPath: nextPathComponent)
        
        let isEnd = nextPathComponent.isEmpty
        if isEnd {
            return group
        }
        
        next: do {
            return append(
                context: context,
                childrenIDs: [group.id],
                path: nextPathComponent
            )
        }
    }
}
