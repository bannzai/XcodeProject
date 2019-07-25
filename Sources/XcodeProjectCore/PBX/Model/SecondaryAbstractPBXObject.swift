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
                _files = newValue
                _files.forEach { file in
                    let isAlreadyExists = context.objects.map { $0.key }.contains(file.id)
                    if isAlreadyExists {
                        return
                    }
                    context.objects[file.id] = file
                }
            }
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
        
        public func appendSourceBuildFile(fileName: String) {
            guard let fileRef = buildPhases.flatMap ({ $0.files })[fileName: fileName]?.fileRef else {
                fatalError("Not exists fileRef for name of \(fileName)")
            }
            let buildPhase = BuildPhaseMakerImpl()
                .makeSourcesBuildPhase(context: context)
            buildPhase.files.append(
                BuildFileMakerImpl()
                    .make(context: context, fileRefId: fileRef.id)
            )
            buildPhases.append(buildPhase)
        }
        public func appendResourceBuildFile(fileName: String) {
            guard let fileRef = buildPhases.flatMap ({ $0.files })[fileName: fileName]?.fileRef else {
                fatalError("Not exists fileRef for name of \(fileName)")
            }
            let buildPhase = BuildPhaseMakerImpl()
                .makeResourcesBuildPhase(context: context)
            buildPhase.files.append(
                BuildFileMakerImpl()
                    .make(context: context, fileRefId: fileRef.id)
            )
            buildPhases.append(buildPhase)
        }
    }
}
