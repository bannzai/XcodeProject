//
//  SecondaryAbstractPBXObject.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

// MARK: - Secondary SuperClasses
extension PBX {
    open class Container : Object {
        
    }
    
    open class ContainerItem: Object {
        
    }
    
    open class ProjectItem: ContainerItem {
        
    }
    
    open class BuildPhase: ProjectItem {
        lazy var _files: [BuildFile] = self.extractObjects(for: "files")
        public var files: [BuildFile] {
            get { return _files }
            set {
                defer {
                    _files = newValue
                }
                let appendDiff = diffing(lhs: newValue, rhs: _files)
                appendDiff.forEach { difference in
                    context.objects[difference.element.id] = difference.element
                }
                let removeDiff = diffing(lhs: _files, rhs: newValue)
                removeDiff.forEach { difference in
                    context.objects[difference.element.id] = nil
                }
            }
        }
        
        public func appendFile(fileName: String) {
            guard let fileRef = context.fileRefs[nameOrPath: fileName] else {
                fatalError("Not exists fileRef for name of \(fileName)")
            }
            let buildFile = BuildFileMakerImpl().make(context: context, fileRefId: fileRef.id)
            files.append(buildFile)
        }
    }
    
    open class Target: ProjectItem {
        open var buildConfigurationList: XC.ConfigurationList { return self.extractObject(for: "buildConfigurationList") }
        open var name: String { return self.extractString(for: "name") }
        open var productName: String { return self.extractString(for:"productName") }
        lazy var _buildPhases: [BuildPhase] = self.extractObjects(for: "buildPhases")
        public var buildPhases: [BuildPhase] {
            get { return _buildPhases}
            set {
                _buildPhases = newValue
                _buildPhases.forEach { buildPhase in
                    let isAlreadyExists = context.objects.map { $0.key }.contains(buildPhase.id)
                    if isAlreadyExists {
                        return
                    }
                    context.objects[buildPhase.id] = buildPhase
                }
            }
        }
        
        @discardableResult public func appendToSourceBuildFile(fileName: String) -> PBX.FileReference {
            guard let fileRef = context.fileRefs[nameOrPath: fileName] else {
                fatalError("Not exists fileRef for name of \(fileName)")
            }
            guard case .sourceCode = KnownFileExtension(fileName: fileName).type else {
                fatalError("Unexpected extensnion \(fileName). It allow .sourceCode type. ")
            }
            BuildFileAppenderImpl()
                .append(
                    context: context,
                    fileRefID: fileRef.id,
                    targetName: name,
                    fileName: fileName
            )
            return fileRef
        }
        
        @discardableResult public func appendToResourceBuildFile(fileName: String) -> PBX.FileReference {
            guard let fileRef = context.fileRefs[nameOrPath: fileName] else {
                fatalError("Not exists fileRef for name of \(fileName)")
            }
            guard case .resourceFile = KnownFileExtension(fileName: fileName).type else {
                fatalError("Unexpected extensnion \(fileName). It allow .resource type. ")
            }
            BuildFileAppenderImpl()
                .append(
                    context: context,
                    fileRefID: fileRef.id,
                    targetName: name,
                    fileName: fileName
            )
            return fileRef
        }
        
        public func removeToSourceBuildFile(fileName: String) {
            guard let fileRef = context.fileRefs[nameOrPath: fileName] else {
                fatalError("Not exists fileRef for name of \(fileName)")
            }
            guard case .sourceCode = KnownFileExtension(fileName: fileName).type else {
                fatalError("Unexpected extensnion \(fileName). It allow .resource type. ")
            }
            
            context
                .buildPhases
                .compactMap { $0 as? PBX.SourcesBuildPhase }
                .forEach { buildPhase in
                    let fileIndex = buildPhase.files.firstIndex { $0.fileRef.id == fileRef.id }
                    
                    switch fileIndex {
                    case .none:
                        return
                    case .some(let fileIndex):
                         buildPhase.files.remove(at: fileIndex)
                        return
                    }
            }
        }
        public func removeToResourceBuildFile(fileName: String) {
            guard let fileRef = context.fileRefs[nameOrPath: fileName] else {
                fatalError("Not exists fileRef for name of \(fileName)")
            }
            guard case .resourceFile = KnownFileExtension(fileName: fileName).type else {
                fatalError("Unexpected extensnion \(fileName). It allow .resource type. ")
            }
            
            context
                .buildPhases
                .compactMap { $0 as? PBX.ResourcesBuildPhase }
                .forEach { buildPhase in
                    let fileIndex = buildPhase.files.firstIndex { $0.fileRef.id == fileRef.id }

                    switch fileIndex {
                    case .none:
                        return
                    case .some(let fileIndex):
                        buildPhase.files.remove(at: fileIndex)
                        return
                    }
            }
        }
    }
}
