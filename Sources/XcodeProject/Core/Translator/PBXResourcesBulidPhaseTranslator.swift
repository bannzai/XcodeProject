//
//  PBXResourcesBulidPhaseTranslator.swift
//  XcodeProjectPackageDescription
//
//  Created by Yudai.Hirose on 2018/01/03.
//

import Foundation

public struct PBXResourcesBuildPhaseTranslator: Translator {
    typealias Object = PBX.ResourcesBuildPhase
    typealias PairType = PBXRawType
    
    func fromPair(with pairType: PairType, allPBX: Context) -> Object {
        // TODO:
        fatalError("undefined")
    }
    
    func toPair(for object: Object) -> PairType {
        let pair: PBXRawType = [
            "isa": object.isa.rawValue,
            "buildActionMask": Int32.max,
            "files": object.files.map { $0.id },
            "runOnlyForDeploymentPostprocessing": 0
        ]
        
        return pair
    }
}
