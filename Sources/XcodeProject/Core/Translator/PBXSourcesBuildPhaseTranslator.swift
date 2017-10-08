//
//  PBX.SourcesBuildPhaseTranslator.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/12/23.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

public struct PBXSourcesBuildPhaseTranslator: Translator {
    typealias Object = PBX.SourcesBuildPhase
    typealias JsonType = XcodeProject.JSON
    
    func fromJson(with jsonType: JsonType, allPBX: AllPBX) -> Object {
        // TODO:
        fatalError("undefined")
    }
    
    func toJson(for object: Object) -> JsonType {
        let json: XcodeProject.JSON = [
            "isa": object.isa.rawValue,
            "buildActionMask": Int32.max,
            "files": object.files.map { $0.id },
            "runOnlyForDeploymentPostprocessing": 0
        ]
        
        return json
    }
}
