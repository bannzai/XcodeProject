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
    private let hashIDGenerator: StringGenerator
    private let groupExtractor: GroupExtractor
    public init(
        hashIDGenerator: StringGenerator = PBXObjectHashIDGenerator(),
        groupExtractor: GroupExtractor = GroupExtractorImpl()
        ) {
        self.hashIDGenerator = hashIDGenerator
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
        
        let isa = ObjectType.PBXGroup.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "children": childrenIDs,
            "path": pathName,
            "sourceTree": "<group>"
        ]
        
        let uuid = hashIDGenerator.generate()
        let group = PBX.Group(
            id: uuid,
            dictionary: pair,
            isa: isa,
            context: context
        )
        
        context.objects[uuid] = group
        
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
                childrenIDs: [uuid],
                path: Array(nextPathComponent).joined(separator: "/")
            )
        }
    }
}
