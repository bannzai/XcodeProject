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
    typealias JsonType = XCProject.JSON
    
    func fromJson(with jsonType: JsonType, allPBX: AllPBX) -> Object {
        // TODO:
        fatalError("undefined")
    }
    
    func toJson(for object: Object) -> JsonType {
        var json: XCProject.JSON = [
            "isa": object.isa.rawValue,
            "children": object.children.map { $0.id },
            "sourceTree": object.sourceTree.value
        ]
        if let name = object.name  {
            json["name"] = name
        }
        if let path = object.path {
            json["path"] = path
        }
        return json
    }
}
