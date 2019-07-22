//
//  XcodeProjectSerializer.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol Serializer {
    func serialize() -> String
}

internal let indent = FormatterIndent.indent
internal let newLine = FormatterIndent.newLine
internal let spaceForOneline = FormatterIndent.spaceForOneline
public struct XcodeProjectSerializer {
    private let project: XcodeProject
    private let xcodeProjectFormatter: XcodeProjectFormatter
    public init(
        project: XcodeProject,
        xcodeProjectFormatter: XcodeProjectFormatter
        ) {
        self.project = project
        self.xcodeProjectFormatter = xcodeProjectFormatter
    }
}

extension XcodeProjectSerializer: Serializer {
    public func serialize() -> String {
        return xcodeProjectFormatter.format(with: project)
    }
}
