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
    
    open class RemoteSwiftPackageReference: PBX.Object {
        open var repositoryURL: String { self.extractString(for: "repositoryURL") }
    }
    
    open class SwiftPackageProductDependency: PBX.Object {
        open var package: RemoteSwiftPackageReference { self.extractObject(for: "package") }
        open var productName: String { self.extractString(for: "package") }
    }
}


