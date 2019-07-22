//
//  PBXProjectParser.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

public protocol Parser {
    func pair() -> PBXRawMapType
    func projectURL() -> URL
    func projectName() -> String
    func context() -> Context
}

public class PBXProjectParser {
    private var cachedContext: Context?
    private let xcodeprojectUrl: URL

    init(xcodeprojectUrl: URL) throws {
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
        
        self.xcodeprojectUrl = xcodeprojectUrl
        
        createContext(allPBX: allPBX)
    }
}

private extension PBXProjectParser {
    func createContext(allPBX: PBXRawMapType) {
        if cachedContext != nil {
            return
        }
        
        let context = InternalContext(allPBX: allPBX)
        cachedContext = context
    }
}

extension PBXProjectParser: Parser {
    public func pair() -> PBXRawMapType {
        return context().allPBX
    }
    
    public func projectURL() -> URL {
        return xcodeprojectUrl
    }
    public func projectName() -> String {
        guard let xcodeProjFile = xcodeprojectUrl
                .pathComponents
                .dropLast() // drop project.pbxproj
                .last // get PROJECTNAME.xcodeproj
            else {
                fatalError("No Xcode project found from \(xcodeprojectUrl.absoluteString), please specify one")
        }
        
        guard let projectName = xcodeProjFile.components(separatedBy: ".").first else {
            fatalError("Can not get project name from \(xcodeProjFile)")
        }

        return projectName
    }
    
    public func context() -> Context {
        return cachedContext!
    }
}
