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
        groupEachPaths: [GroupPathPair],
        childId: String,
        groupPathNames: [String]
    )
}

public struct GroupAppenderImpl: GroupAppender {
    private let hashIDGenerator: StringGenerator
    public init(
        hashIDGenerator: StringGenerator
        ) {
        self.hashIDGenerator = hashIDGenerator
    }
    
    public func append(
        context: Context,
        groupEachPaths: [GroupPathPair],
        childId: String,
        groupPathNames: [String]
        ) {
        if groupPathNames.isEmpty {
            return
        }
        
        let groupPath = groupPathNames.joined(separator: "/")
        let alreadyExistsGroup = groupEachPaths
            .filter { (group, path) -> Bool in
                return path == groupPath
            }
            .first
        
        if let group = alreadyExistsGroup?.0 {
            let reference: PBX.Reference = context.objects[childId] as! PBX.Reference
            group.children.append(reference)
            return
        } else {
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
                groupEachPaths: groupEachPaths,
                childId: uuid,
                groupPathNames: Array(groupPathNames.dropLast())
            )
        }
    }
}
