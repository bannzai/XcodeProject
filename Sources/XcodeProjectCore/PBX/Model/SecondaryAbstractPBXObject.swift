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
        open var buildPhases: [BuildPhase] { return self.extractObjects(for: "buildPhases") }
    }
}
