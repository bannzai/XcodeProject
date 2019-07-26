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
                let differences = _files
                    .enumerated()
                    .filter  { (index, _file) in !newValue.contains { n in n.id == _file.id } }
                
                differences.forEach { difference in
                    switch _files.contains (where: { $0.id == difference.element.id }) {
                    case true:
                        context.objects[difference.element.id] = nil
                    case false:
                        context.objects[difference.element.id] = difference.element
                    }
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
        
        public func appendToSourceBuildFile(fileName: String) {
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
        }
        
        public func appendToResourceBuildFile(fileName: String) {
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
                .forEach { buildPhase in
                    let fileIndex = buildPhase.files.firstIndex { $0.id == fileRef.id }
                    
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
                .forEach { buildPhase in
                    let fileIndex = buildPhase.files.firstIndex { $0.id == fileRef.id }
                    
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
