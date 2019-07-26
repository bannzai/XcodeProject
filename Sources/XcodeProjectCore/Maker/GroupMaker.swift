//
//  GroupMaker.swift
//  XcodeProjectCore
//
//  Created by Yudai Hirose on 2019/07/26.
//

import Foundation

public protocol GroupMaker {
    func make(context: Context, childrenIds: [String], pathName: String) -> PBX.Group
}

public struct GroupMakerImpl: GroupMaker {
    private let idGenerator: StringGenerator
    public init(
        idGenerator: StringGenerator = PBXObjectHashIDGenerator()
        ) {
        self.idGenerator = idGenerator
    }
    
    public func make(context: Context, childrenIds: [String] = [], pathName: String) -> PBX.Group {
        let isa = ObjectType.PBXGroup.rawValue
        let pair: PBXRawMapType = [
            "isa": isa,
            "children": childrenIds,
            "path": pathName,
            "sourceTree": "<group>"
        ]
        
        let uuid = idGenerator.generate()
        let group = PBX.Group(
            id: uuid,
            dictionary: pair,
            isa: isa,
            context: context
        )
        return group
    }
    
}
