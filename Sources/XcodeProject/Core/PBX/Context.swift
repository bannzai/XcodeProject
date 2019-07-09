//
//  Allswift
//  xcp
//
//  Created by kingkong999yhirose on 2016/12/23.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import Foundation

open class Context {
    typealias PathType = [String: PathComponent]
    var dictionary: [String: PBX.Object] = [:]
    var fullFilePaths: PathType = [:]
    
    func object<T: PBX.Object>(for key: String) -> T {
        guard let object = dictionary[key] as? T else {
            fatalError(assertionMessage(description: "wrong format is \(type(of: self)): \(key)"))
        }
        return object
    }
    
    public func resetFullFilePaths(with project: PBX.Project) {
        fullFilePaths.removeAll()
        
        createFileRefPath(with: project.mainGroup)
        createFileRefForSubGroupPath(with: project.mainGroup)
        createGroupPath(with: project.mainGroup, parentPath: "")
    }
    
    fileprivate func createGroupPath(with group: PBX.Group, parentPath: String) {
        let path = group.path ?? group.name ?? ""
        group.fullPath = ""
        group.fullPath = parentPath + "/" + path
        group.subGroups.forEach { createGroupPath(with: $0, parentPath: group.fullPath) }
    }
    
    fileprivate func createFileRefForSubGroupPath(with group: PBX.Group, prefix: String = "") {
        group
            .subGroups
            .forEach { subGroup in
                guard let path = subGroup.path else {
                    createFileRefPath(with: subGroup, prefix: prefix)
                    createFileRefForSubGroupPath(with: subGroup, prefix: prefix)
                    return
                }
                let nextPrefix: String
                switch group.sourceTree {
                case .group:
                    nextPrefix = generatePath(with: prefix, path: path)
                default:
                    nextPrefix = prefix
                }
                createFileRefPath(with: subGroup, prefix: nextPrefix)
                createFileRefForSubGroupPath(with: subGroup, prefix: nextPrefix)
        }
    }
    
    fileprivate func createFileRefPath(with group: PBX.Group, prefix: String = "") {
        group
            .fileRefs
            .forEach { reference in
                guard let path = reference.path else {
                    return
                }
                switch (reference.sourceTree, group.sourceTree) {
                case (.group, .group) :
                    fullFilePaths[reference.id] = .environmentPath(.SOURCE_ROOT, generatePath(with: prefix, path: path))
                case (.group, .absolute) :
                    fullFilePaths[reference.id] = .simple(generatePath(with: prefix, path: path))
                case (.group, .folder(let environment)) :
                    fullFilePaths[reference.id] = .environmentPath(environment, generatePath(with: prefix, path: path))
                case (.absolute, _):
                    fullFilePaths[reference.id] = .simple(path)
                case (.folder(let environment), _):
                    fullFilePaths[reference.id] = .environmentPath(environment, generatePath(with: prefix, path: path))
                }
        }
    }
    
    fileprivate func generatePath(with prefix: String, path: String) -> String {
        return prefix + "/" + path
    }
}
