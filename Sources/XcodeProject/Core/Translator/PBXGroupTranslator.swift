//
//  PBX.GroupTranslator.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/12/23.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

public struct PBXGroupTranslator: Translator {
    typealias Object = PBX.Group
    typealias PairType = PBXPair
    
    func fromPair(with pairType: PairType, allPBX: AllPBX) -> Object {
        // TODO:
        fatalError("undefined")
    }
    
    func toPair(for object: Object) -> PairType {
        var pair: PBXPair = [
            "isa": object.isa.rawValue,
            "children": object.children.map { $0.id },
            "sourceTree": object.sourceTree.value
        ]
        if let name = object.name  {
            pair["name"] = name
        }
        if let path = object.path {
            pair["path"] = path
        }
        return pair
    }
}
