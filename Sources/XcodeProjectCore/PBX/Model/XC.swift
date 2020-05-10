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
        internal var _productDependency: SwiftPackageProductDependency?
        open var productDependency: SwiftPackageProductDependency {
            if let productDependency = _productDependency {
                return productDependency
            }
            let productDependency = context
                .objects
                .values
                .compactMap { $0 as? XC.SwiftPackageProductDependency }
                .first { $0.package === self }!
            _productDependency = productDependency
            return productDependency
        }
        open var productDependencyName: String { productDependency.productName }
        open var repositoryURL: String { self.extractString(for: "repositoryURL") }
    }
    
    open class SwiftPackageProductDependency: PBX.Object {
        open var package: RemoteSwiftPackageReference { self.extractObject(for: "package") }
        open var productName: String { self.extractString(for: "package") }
    }
}


