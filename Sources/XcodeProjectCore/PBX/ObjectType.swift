//
//  ObjectType.swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/12/23.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

// ObjectType is a each PBX Object type in project.pbxproj.
public enum ObjectType: String {
    case PBXProject
    case PBXContainerItemProxy
    case PBXBuildFile
    case PBXCopyFilesBuildPhase
    case PBXFrameworksBuildPhase
    case PBXHeadersBuildPhase
    case PBXResourcesBuildPhase
    case PBXShellScriptBuildPhase
    case PBXSourcesBuildPhase
    case PBXBuildStyle
    case XCBuildConfiguration
    case PBXAggregateTarget
    case PBXNativeTarget
    case PBXTargetDependency
    case XCConfigurationList
    case PBXReference
    case PBXReferenceProxy
    case PBXFileReference
    case PBXGroup
    case PBXVariantGroup
    case XCVersionGroup
    case XCRemoteSwiftPackageReference
    case XCSwiftPackageProductDependency
    
    public init(for isa: String) {
        guard let type = ObjectType(rawValue: isa) else {
            fatalError(assertionMessage(description: "unknown type from: \(isa)"))
        }
        
        self = type
    }
    
    public static func type(with string: String) -> PBX.Object.Type {
        guard let typeString = ObjectType(rawValue: string) else {
            fatalError(assertionMessage(description: "unknown type from: \(string)"))
        }
        return type(with: typeString)
    }
    
    public static func type(with type: ObjectType) -> PBX.Object.Type {
        switch type {
        case PBXProject:
            return PBX.Project.self
        case PBXContainerItemProxy:
            return PBX.ContainerItemProxy.self
        case PBXBuildFile:
            return PBX.BuildFile.self
        case PBXCopyFilesBuildPhase:
            return PBX.CopyFilesBuildPhase.self
        case PBXFrameworksBuildPhase:
            return PBX.FrameworksBuildPhase.self
        case PBXHeadersBuildPhase:
            return PBX.HeadersBuildPhase.self
        case PBXResourcesBuildPhase:
            return PBX.ResourcesBuildPhase.self
        case PBXShellScriptBuildPhase:
            return PBX.ShellScriptBuildPhase.self
        case PBXSourcesBuildPhase:
            return PBX.SourcesBuildPhase.self
        case PBXBuildStyle:
            return PBX.BuildStyle.self
        case XCBuildConfiguration:
            return XC.BuildConfiguration.self
        case PBXAggregateTarget:
            return PBX.AggregateTarget.self
        case PBXNativeTarget:
            return PBX.NativeTarget.self
        case PBXTargetDependency:
            return PBX.TargetDependency.self
        case XCConfigurationList:
            return XC.ConfigurationList.self
        case PBXReference:
            return PBX.Reference.self
        case PBXReferenceProxy:
            return PBX.ReferenceProxy.self
        case PBXFileReference:
            return PBX.FileReference.self
        case PBXGroup:
            return PBX.Group.self
        case PBXVariantGroup:
            return PBX.VariantGroup.self
        case XCVersionGroup:
            return XC.VersionGroup.self
        case .XCRemoteSwiftPackageReference:
            return XC.RemoteSwiftPackageReference.self
        case .XCSwiftPackageProductDependency:
            return XC.SwiftPackageProductDependency.self
        }
    }
}
