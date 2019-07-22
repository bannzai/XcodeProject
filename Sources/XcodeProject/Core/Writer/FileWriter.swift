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
    private let serializer: XcodeProjectSerializer
    public init(serializer: XcodeProjectSerializer) {
        self.serializer = serializer
    }
    public func write(xcodeProject: XcodeProject) throws {
        try serializer.serialize().write(
            to: xcodeProject.context.xcodeprojectUrl,
            atomically: true,
            encoding: .utf8
        )
    }
}
