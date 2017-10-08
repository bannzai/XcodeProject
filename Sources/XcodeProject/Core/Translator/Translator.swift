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
    associatedtype PairType
    
    func fromPair(with pairType: PairType, allPBX: AllPBX) -> Object
    func toPair(for object: Object) -> PairType
}
