//
//  XcodeProjectSerializer.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol Serializer {
    func serialize(project: XcodeProject) -> String
}

public struct XcodeProjectSerializer {
    private let xcodeProjectFormatter: XcodeProjectFormatter
    public init(
        xcodeProjectFormatter: XcodeProjectFormatter = XcodeProjectFormatterImpl()
        ) {
        self.xcodeProjectFormatter = xcodeProjectFormatter
    }
}

extension XcodeProjectSerializer: Serializer {
    public func serialize(project: XcodeProject) -> String {
        return xcodeProjectFormatter.format(project: project)
    }
}
