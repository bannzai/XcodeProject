//
//  PBXResourcesBulidPhaseTranslator.swift
//  XcodeProjectPackageDescription
//
//  Created by Yudai.Hirose on 2018/01/03.
//

import Foundation

public struct PBXResourcesBuildPhaseTranslator: Translator {
    typealias Object = PBX.ResourcesBuildPhase
    typealias PairType = PBXPair
    
    func fromPair(with pairType: PairType, allPBX: AllPBX) -> Object {
        // TODO:
        fatalError("undefined")
    }
    
    func toPair(for object: Object) -> PairType {
        let pair: PBXPair = [
            "isa": object.isa.rawValue,
            "buildActionMask": Int32.max,
            "files": object.files.map { $0.id },
            "runOnlyForDeploymentPostprocessing": 0
        ]
        
        return pair
    }
}
