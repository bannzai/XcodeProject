//
//  BuildPhaseAppender.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/24.
//

import Foundation

public protocol BuildPhaseAppender {
    @discardableResult func append(context: Context, buildFile: PBX.BuildFile, target: PBX.NativeTarget) -> PBX.BuildPhase
}
