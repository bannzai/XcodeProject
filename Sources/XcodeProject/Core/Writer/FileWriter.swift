//
//  FileWriter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol Writer {
    func write(content: String, destinationURL: URL) throws
}

public struct FileWriter: Writer {
    public init() { }
    public func write(content: String, destinationURL: URL) throws {
        try content.write(
            to: destinationURL,
            atomically: true,
            encoding: String.Encoding.utf8
        )
    }
}
