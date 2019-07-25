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
    private let groupExtractor: GroupExtractor
    public init(
        maker: GroupMaker = GroupMakerImpl(),
        groupExtractor: GroupExtractor = GroupExtractorImpl()
        ) {
        self.maker = maker
        self.groupExtractor = groupExtractor
    }
    
    @discardableResult public func append(
        context: Context,
        childrenIDs: [PBXObjectIDType],
        path: PBXRawPathType
        ) -> PBX.Group {
        if path.isEmpty {
            fatalError("Unexpected for path is empty")
        }
        
        if let alreadyExistsGroup = groupExtractor.extract(context: context, path: path) {
            return alreadyExistsGroup
        }

        let groupPathNames = path.components(separatedBy: "/")
        guard let pathName = groupPathNames.last else {
            fatalError("unexpected not exists last value")
        }
        
        let group = maker.make(context: context, childrenIds: childrenIDs, pathName: pathName)
        context.objects[group.id] = group
        
        defer {
            // FIXME:
            context.resetGroupFullPaths()
        }
        
        let nextPathComponent = groupPathNames.dropLast()
        let isEnd = nextPathComponent.isEmpty
        if isEnd {
            return group
        }
        
        next: do {
            return append(
                context: context,
                childrenIDs: [group.id],
                path: Array(nextPathComponent).joined(separator: "/")
            )
        }
    }
}
