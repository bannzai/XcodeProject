//
//  swift
//  xcp
//
//  Created by kingkong999yhirose on 2016/09/20.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

// MARK: - Name space
public enum /* prefix */ PBX { }

extension /* prefix */ PBX {
    open class Project: Object {
        open var developmentRegion: String  { return self.extractString(for: "developmentRegion") }
        open var hasScannedForEncodings: Bool { return self.extractBool(for: "hasScannedForEncodings") }
        open var knownRegions: [String] { return self.extractStrings(for: "knownRegions") }
        open var targets: [PBX.NativeTarget] { return self.extractObjects(for: "targets") }
        open var mainGroup: PBX.Group { return self.extractObject(for: "mainGroup") }
        open var buildConfigurationList: XC.ConfigurationList { return self.extractObject(for: "buildConfigurationList") }
        open var attributes: PBXRawMapType { return self.extractPair(for: "attributes") }
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
        override open var objectDictionary: PBXRawMapType {
            return [
                "isa": isa.rawValue,
                "buildActionMask": Int32.max,
                "files": files.map { $0.id },
                "runOnlyForDeploymentPostprocessing": 0
            ]
        }
    }
    
    open class ShellScriptBuildPhase: PBX.BuildPhase {
        open var name: String? { return self.extractStringIfExists(for: "name") }
        open var shellScript: String { return self.extractString(for: "shellScript") }
    }
    
    open class SourcesBuildPhase: PBX.BuildPhase {
        override open var objectDictionary: PBXRawMapType {
             return [
                "isa": isa.rawValue,
                "buildActionMask": Int32.max,
                "files": files.map { $0.id },
                "runOnlyForDeploymentPostprocessing": 0
            ]
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
        private lazy var _name: String? = self.extractStringIfExists(for: "name")
        open var name: String? {
            get { return _name }
            set {
                _name = newValue
                dictionary["name"] = _name
            }
        }
        private lazy var _path: String? = self.extractStringIfExists(for: "path")
        open var path: String? {
            get { return _path }
            set {
                _path = newValue
                dictionary["path"] = _path
            }
        }
        
        public weak var parentGroup: PBX.Group?

        public var pathOrNameOrEmpty: String {
            return path ?? name ?? ""
        }
        
        public var fileSystemAbsolutePath: String {
            switch sourceTree {
            case .group:
                break
            case .absolute:
                // Maybe not nil
                return path!
            case .environment(let env):
                switch env {
                case .SOURCE_ROOT:
                    // Maybe not nil
                    return path!
                case _:
                    fatalError("Unexpected pattern \(sourceTree)")
                }
            }
            
            var next = parentGroup
            var expectedFullPath = ""
            if let path = self.path {
                expectedFullPath = path
            }
            while let parentGroup = next {
                if context.mainGroup === parentGroup {
                    break
                }
                if let path = parentGroup.path {
                    expectedFullPath = path + "/" + expectedFullPath
                }
                next = next?.parentGroup
            }
            expectedFullPath = context.xcodeprojectDirectoryURL.path + "/" + expectedFullPath
            return expectedFullPath
        }
        public var expectedFileSystemAbsolutePath: String {
            switch sourceTree {
            case .group:
                break
            case .absolute:
                // Maybe not nil
                return path!
            case .environment(let env):
                switch env {
                case .SOURCE_ROOT:
                    // Maybe not nil
                    return path!
                case _:
                    fatalError("Unexpected pattern \(sourceTree)")
                }
            }
            
            var next = parentGroup
            var expectedFullPath = pathOrNameOrEmpty
            while let parentGroup = next {
                if context.mainGroup === parentGroup {
                    break
                }
                expectedFullPath = parentGroup.pathOrNameOrEmpty + "/" + expectedFullPath
                next = next?.parentGroup
            }
            expectedFullPath = context.xcodeprojectDirectoryURL.path + "/" + expectedFullPath
            return expectedFullPath
        }
        
        public lazy var sourceTree: SourceTreeType = SourceTreeType(for: extractString(for: "sourceTree"))
    }
    
    open class ReferenceProxy: Reference {
        // convenience accessor
        open var remoteRef: ContainerItemProxy { return self.extractObject(for: "remoteRef") }
    }
    
    open class FileReference: Reference {
        // convenience accessor
        open var fullPath: String = ""
    }
    
    open class Group: Reference {
        override open var objectDictionary: PBXRawMapType {
            var pair: PBXRawMapType = [
                "isa": isa.rawValue,
                "children": children.map { $0.id },
                "sourceTree": sourceTree.value
            ]
            if let name = name  {
                pair["name"] = name
            }
            if let path = path {
                pair["path"] = path
            }
            return pair
        }
        
        lazy var _children: [Reference] = self.extractObjects(for: "children")
        public var children: [Reference] {
            get { return _children }
            set {
                defer {
                    _children = newValue
                }
                let appendDiff = diffing(lhs: newValue, rhs: _children)
                appendDiff.forEach { difference in
                    context.objects[difference.element.id] = difference.element
                }
                let removeDiff = diffing(lhs: _children, rhs: newValue)
                removeDiff.forEach { difference in
                    context.objects[difference.element.id] = nil
                }
            }
        }
        
        open var fullPath: String = ""
        
        // convenience accessor
        open var subGroups: [Group] { return children.ofType(PBX.Group.self) }
        open var fileRefs: [PBX.FileReference] { return children.ofType(PBX.FileReference.self) }
        
        public func appendFile(name: String) {
            children.append(
                FileReferenceMakerImpl()
                    .make(context: context, fileName: name)
            )
        }

        public func appendGroup(name: String) {
            children.append(GroupMakerImpl().make(context: context, pathName: name))
        }
        
        @discardableResult public func removeFile(fileName: String) -> PBX.FileReference? {
            guard let fileRef = FileRefExtractorImpl().extract(context: context, groupPath: fullPath, fileName: fileName) else {
                fatalError("Could not find file reference for filename of \(fileName)")
            }
            
            let index = children.firstIndex { $0.id == fileRef.id }
            switch index {
            case .none:
                assertionFailure(assertionMessage(description: "Maybe should exists index"))
            case .some(let index):
                children.remove(at: index)
            }
            
            return fileRef
        }
    }
    
    open class VariantGroup: PBX.Group {
        
    }
    
}
