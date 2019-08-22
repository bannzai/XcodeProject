//
//  FileSystemWriter.swift
//  Commander
//
//  Created by Yudai Hirose on 2019/08/22.
//

import Foundation

public protocol FileSystemWriter: AutoMockable {
    func move(source: String, destination: String) throws
    func createDirectory(path: String) throws
    func remove(path: String) throws
    func isExistsFile(path: String) -> Bool
    func isExistsDirectory(path: String) -> Bool
}

public struct FileSystemWriterImpl: FileSystemWriter {
    public init() {
        
    }
    public func move(source: String, destination: String) throws {
        try FileManager.default.moveItem(atPath: source, toPath: destination)
    }
    
    public func createDirectory(path: String) throws {
        try FileManager.default.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
    }
    
    public func remove(path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    public func isExistsFile(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    public func isExistsDirectory(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}
