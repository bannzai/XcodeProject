//
//  GroupAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/23.
//

import Foundation

public typealias GroupPathPair = (PBX.Group, String)
public protocol GroupAppender {
    func append(
        context: Context,
        childId: String,
        path: String
    )
}

public struct GroupAppenderImpl: GroupAppender {
    private let hashIDGenerator: StringGenerator
    public init(
        hashIDGenerator: StringGenerator
        ) {
        self.hashIDGenerator = hashIDGenerator
    }
    
    internal func group(context: Context, for path: String) -> PBX.Group? {
        return context
            .objects
            .values
            .compactMap { $0 as? PBX.Group }
            .filter { $0.fullPath == path }
            .last
    }
    
    public func append(
        context: Context,
        childId: String,
        path: String
        ) {
        if path.isEmpty {
            return
        }
        
        if let lastGroup = group(context: context, for: path) {
            if let reference = context.objects[childId] as? PBX.Group {
                lastGroup.children.append(reference)
            }
            return
        }
        
        let groupPathNames = path.components(separatedBy: "/")
        guard let pathName = groupPathNames.last else {
            fatalError("unexpected not exists last value")
        }
        
        let isa = ObjectType.PBXGroup.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "children": [
                childId
            ],
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
        append(
            context: context,
            childId: uuid,
            path: Array(groupPathNames.dropLast()).joined(separator: "/")
        )
    }
}
