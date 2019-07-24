//
//  PBXProjectContextParser.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol ContextParser {
    func parse(xcodeprojectUrl: URL) throws -> Context
}

public class PBXProjectContextParser {
    public init() {
        
    }
}

extension PBXProjectContextParser: ContextParser {
    public func parse(xcodeprojectUrl: URL) throws -> Context {
        guard
            let propertyList = try? Data(contentsOf: xcodeprojectUrl)
            else {
                throw XcodeProjectError.notExistsProjectFile
        }
        var format: PropertyListSerialization.PropertyListFormat = PropertyListSerialization.PropertyListFormat.binary
        let properties = try PropertyListSerialization.propertyList(from: propertyList, options: PropertyListSerialization.MutabilityOptions(), format: &format)
        
        guard
            let allPBX = properties as? PBXRawMapType
            else {
                throw XcodeProjectError.wrongFileFormat
        }
        
        let context = InternalContext(allPBX: allPBX, xcodeProjectUrl: xcodeprojectUrl)
        return context
    }
}
