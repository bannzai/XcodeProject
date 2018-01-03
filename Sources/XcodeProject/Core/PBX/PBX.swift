//
//  swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/20.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

open class /* prefix */ PBX {
    // MARK: - Abstract
    open class Object {
        open let id: String
        open let dictionary: PBXPair
        open let isa: ObjectType
        open let allPBX: AllPBX
        
        // FIXME:
        open var objectDictionary: PBXPair {
            return dictionary
        }
        
        public required init(
            id: String,
            dictionary: PBXPair,
            isa: String,
            allPBX: AllPBX
            ) {
            self.id = id
            self.dictionary = dictionary
            self.isa = ObjectType(for: isa)
            self.allPBX = allPBX
        }
        
        fileprivate func extractStringIfExists(for key: String) -> String? {
            return dictionary[key] as? String
        }
        
        fileprivate func extractString(for key: String) -> String {
            guard let value = extractStringIfExists(for: key) else {
                fatalError(assertionMessage(description: "wrong format is type: \(type(of: self)), key: \(key), id: \(id)"))
            }
            return value
        }
        
        fileprivate func extractStrings(for key: String) -> [String] {
            guard let value = dictionary[key] as? [String] else {
                fatalError(assertionMessage(description: "wrong format is type: \(type(of: self)), key: \(key), id: \(id)"))
            }
            return value
        }
        
        fileprivate func extractBool(for key: String) -> Bool {
            let boolString: String = extractString(for: key)
            
            switch boolString {
            case "0":
                return false
            case "1":
                return true
            default:
                fatalError(assertionMessage(description: "unknown bool string: \(boolString)"))
                
            }
        }
        
        fileprivate func extractObject<T: PBX.Object>(for key: String) -> T {
            let objectKey = extractString(for: key)
            return allPBX.object(for: objectKey)
        }
        
        fileprivate func extractObjects<T: PBX.Object>(for key: String) -> [T] {
            let objectKeys = extractStrings(for: key)
            return objectKeys.map(allPBX.object)
        }
        
        fileprivate func extractPair(for key: String) -> PBXPair {
            return dictionary[key] as! PBXPair
        }
    }
    
    open class Container : Object {
        
    }
    
    open class ContainerItem: Object {
        
    }
    
    open class ProjectItem: ContainerItem {
        
    }
    
    open class BuildPhase: ProjectItem {
        open lazy var files: [BuildFile] = self.extractObjects(for: "files")
    }
    
    open class Target: ProjectItem {
        open var buildConfigurationList: XC.ConfigurationList { return self.extractObject(for: "buildConfigurationList") }
        open var name: String { return self.extractString(for: "name") }
        open var productName: String { return self.extractString(for:"productName") }
        open var buildPhases: [BuildPhase] { return self.extractObjects(for: "buildPhases") }
    }
    
    
}

extension /* prefix */ PBX {
    open class Project: Object {
        open var developmentRegion: String  { return self.extractString(for: "developmentRegion") }
        open var hasScannedForEncodings: Bool { return self.extractBool(for: "hasScannedForEncodings") }
        open var knownRegions: [String] { return self.extractStrings(for: "knownRegions") }
        open var targets: [PBX.NativeTarget] { return self.extractObjects(for: "targets") }
        open var mainGroup: PBX.Group { return self.extractObject(for: "mainGroup") }
        open var buildConfigurationList: XC.ConfigurationList { return self.extractObject(for: "buildConfigurationList") }
        open var attributes: PBXPair { return self.extractPair(for: "attributes") }
    }
    
    open class ContainerItemProxy: ContainerItem {
        
    }
    
    open class BuildFile: ProjectItem {
        open var fileRef: PBX.Reference { return self.extractObject(for: "fileRef") }
    }
    
    open class CopyFilesBuildPhase: PBX.BuildPhase {
        open var name: String? { return self.extractStringIfExists(for: "name") }
    }
    
    open class FrameworksBuildPhase: PBX.BuildPhase {
        
    }
    
    open class HeadersBuildPhase: PBX.BuildPhase {
        
    }
    
    open class ResourcesBuildPhase: PBX.BuildPhase {
        
    }
    
    open class ShellScriptBuildPhase: PBX.BuildPhase {
        open var name: String? { return self.extractStringIfExists(for: "name") }
        open var shellScript: String { return self.extractString(for: "shellScript") }
    }
    
    open class SourcesBuildPhase: PBX.BuildPhase {
        override open var objectDictionary: PBXPair {
            return PBXSourcesBuildPhaseTranslator().toPair(for: self)
        }
    }
    
    open class BuildStyle: ProjectItem {
        
    }
    
    open class AggregateTarget: Target {
        
    }
    
    open class NativeTarget: Target {
        
    }
    
    open class TargetDependency: ProjectItem {
        
    }
    
    open class Reference: ContainerItem {
        open var name: String? { return self.extractStringIfExists(for: "name") }
        open var path: String? { return self.extractStringIfExists(for: "path") }
        open var sourceTree: SourceTreeType { return SourceTreeType(for: self.extractString(for: "sourceTree")) }
    }
    
    open class ReferenceProxy: Reference {
        // convenience accessor
        open var remoteRef: ContainerItemProxy { return self.extractObject(for: "remoteRef") }
    }
    
    open class FileReference: Reference {
        // convenience accessor
        open var fullPath: PathComponent {
            return self.generateFullPath()
        }
        
        fileprivate func generateFullPath() -> PathComponent {
            guard let path = allPBX.fullFilePaths[self.id] else {
                fatalError(assertionMessage(description:
                    "unexpected id: \(id)",
                    "and fullFilePaths: \(allPBX.fullFilePaths)"
                    )
                )
            }
            return path
        }
    }
    
    open class Group: Reference {
        override open var objectDictionary: PBXPair {
            return PBXGroupTranslator().toPair(for: self)
        }
        
        open lazy var children: [Reference] = self.extractObjects(for: "children")
        open var fullPath: String = ""
        
        // convenience accessor
        open var subGroups: [Group] { return self.makeSubGroups() }
        open var fileRefs: [PBX.FileReference] { return self.makeFileRefs() }
        
        func makeSubGroups() -> [Group] {
            return self.children.ofType(PBX.Group.self)
        }
        
        func makeFileRefs() -> [PBX.FileReference] {
            return self.children.ofType(PBX.FileReference.self)
        }
    }
    
    open class VariantGroup: PBX.Group {
        
    }
    
}
open class /* prefix */ XC {
    open class BuildConfiguration: PBX.BuildStyle {
        open var name: String { return self.extractString(for: "name") }
    }
    
    open class VersionGroup: PBX.Reference {
        
    }
    
    open class ConfigurationList: PBX.ProjectItem {
        
    }
    
}

