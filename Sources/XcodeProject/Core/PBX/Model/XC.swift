//
//  XC.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation

open class /* prefix */ XC {
    open class BuildConfiguration: PBX.BuildStyle {
        open var name: String { return self.extractString(for: "name") }
    }
    
    open class VersionGroup: PBX.Reference {
        
    }
    
    open class ConfigurationList: PBX.ProjectItem {
        
    }
}


