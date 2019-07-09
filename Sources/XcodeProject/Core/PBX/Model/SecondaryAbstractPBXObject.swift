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
        open lazy var files: [BuildFile] = self.extractObjects(for: "files")
    }
    
    open class Target: ProjectItem {
        open var buildConfigurationList: XC.ConfigurationList { return self.extractObject(for: "buildConfigurationList") }
        open var name: String { return self.extractString(for: "name") }
        open var productName: String { return self.extractString(for:"productName") }
        open var buildPhases: [BuildPhase] { return self.extractObjects(for: "buildPhases") }
    }
}
