//
//  FileWriter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol Writer {
    func write(xcodeProject: XcodeProject) throws
}

public struct FileWriter: Writer {
    private let serializer: Serializer
    
    public init(serializer: Serializer = XcodeProjectSerializer()) {
        self.serializer = serializer
    }
    
    public func write(xcodeProject: XcodeProject) throws {
        try serializer.serialize(project: xcodeProject).write(
            to: xcodeProject.context.xcodeprojectUrl,
            atomically: true,
            encoding: .utf8
        )
    }
}
