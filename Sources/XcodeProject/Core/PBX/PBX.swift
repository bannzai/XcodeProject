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
        open let dictionary: XcodeProject.JSON
        open let isa: ObjectType
        open let allPBX: AllPBX
        
        // FIXME:
        open var objectDictionary: XcodeProject.JSON {
            return dictionary
        }
        
        public required init(
            id: String,
            dictionary: XcodeProject.JSON,
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
        
        fileprivate func extractJson(for key: String) -> XcodeProject.JSON {
            return dictionary[key] as! XcodeProject.JSON
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
        open fileprivate(set) lazy var buildConfigurationList: XC.ConfigurationList = self.extractObject(for: "buildConfigurationList")
        open fileprivate(set) lazy var name: String = self.extractString(for: "name")
        open fileprivate(set) lazy var productName: String = self.extractString(for:"productName")
        open fileprivate(set) lazy var buildPhases: [BuildPhase] = self.extractObjects(for: "buildPhases")
    }
    
    
}

extension /* prefix */ PBX {
    open class Project: Object {
        open fileprivate(set) lazy var developmentRegion: String = self.extractString(for: "developmentRegion")
        open fileprivate(set) lazy var hasScannedForEncodings: Bool = self.extractBool(for: "hasScannedForEncodings")
        open fileprivate(set) lazy var knownRegions: [String] = self.extractStrings(for: "knownRegions")
        open fileprivate(set) lazy var targets: [PBX.NativeTarget] = self.extractObjects(for: "targets")
        open fileprivate(set) lazy var mainGroup: PBX.Group = self.extractObject(for: "mainGroup")
        open fileprivate(set) lazy var buildConfigurationList: XC.ConfigurationList = self.extractObject(for: "buildConfigurationList")
        open fileprivate(set) lazy var attributes: XcodeProject.JSON = self.extractJson(for: "attributes")
    }
    
    open class ContainerItemProxy: ContainerItem {
        
    }
    
    open class BuildFile: ProjectItem {
        open lazy var fileRef: PBX.Reference = self.extractObject(for: "fileRef")
    }
    
    open class CopyFilesBuildPhase: PBX.BuildPhase {
        open fileprivate(set) lazy var name: String? = self.extractStringIfExists(for: "name")
    }
    
    open class FrameworksBuildPhase: PBX.BuildPhase {
        
    }
    
    open class HeadersBuildPhase: PBX.BuildPhase {
        
    }
    
    open class ResourcesBuildPhase: PBX.BuildPhase {
        
    }
    
    open class ShellScriptBuildPhase: PBX.BuildPhase {
        open fileprivate(set) lazy var name: String? = self.extractStringIfExists(for: "name")
        open fileprivate(set) lazy var shellScript: String = self.extractString(for: "shellScript")
    }
    
    open class SourcesBuildPhase: PBX.BuildPhase {
        override open var objectDictionary: XcodeProject.JSON {
            return PBXSourcesBuildPhaseTranslator().toJson(for: self)
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
        open fileprivate(set) lazy var name: String? = self.extractStringIfExists(for: "name")
        open fileprivate(set) lazy var path: String? = self.extractStringIfExists(for: "path")
        open fileprivate(set) lazy var sourceTree: SourceTreeType = SourceTreeType(for: self.extractString(for: "sourceTree"))
    }
    
    open class ReferenceProxy: Reference {
        // convenience accessor
        open fileprivate(set) lazy var remoteRef: ContainerItemProxy = self.extractObject(for: "remoteRef")
    }
    
    open class FileReference: Reference {
        // convenience accessor
        open lazy var fullPath: PathComponent = self.generateFullPath()
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
        override open var objectDictionary: XcodeProject.JSON {
            return PBXGroupTranslator().toJson(for: self)
        }
        
        open lazy var children: [Reference] = self.extractObjects(for: "children")
        open var fullPath: String = ""
        
        // convenience accessor
        open lazy var subGroups: [Group] = self.children.ofType(PBX.Group.self)
        open lazy var fileRefs: [PBX.FileReference] = self.children.ofType(PBX.FileReference.self)
    }
    
    open class VariantGroup: PBX.Group {
        
    }
    
}
open class /* prefix */ XC {
    open class BuildConfiguration: PBX.BuildStyle {
        open fileprivate(set) lazy var name: String = self.extractString(for: "name")
    }
    
    open class VersionGroup: PBX.Reference {
        
    }
    
    open class ConfigurationList: PBX.ProjectItem {
        
    }
    
}
