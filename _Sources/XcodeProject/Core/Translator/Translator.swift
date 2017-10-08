//
//  Translator.swift
//  Kuri
//
//  Created by 廣瀬雄大 on 2016/12/18.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

protocol Translator {
    associatedtype Object
    associatedtype JsonType
    
    func fromJson(with jsonType: JsonType, allPBX: AllPBX) -> Object
    func toJson(for object: Object) -> JsonType
}
