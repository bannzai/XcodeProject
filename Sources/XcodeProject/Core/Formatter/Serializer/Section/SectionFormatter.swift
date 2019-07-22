//
//  SectionFormatter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public protocol SectionFormatter: SerializeFormatter {
    func format(isa: ObjectType, objects: [PBX.Object]) -> String
}

public struct SectionFormatterImpl: SectionFormatter {
    public let project: XcodeProject
    private let rowFormatter: SectionRowFormatter
    public init(
        project: XcodeProject,
        rowFormatter: SectionRowFormatter
        ) {
        self.project = project
        self.rowFormatter = rowFormatter
    }
    
    public func format(isa: ObjectType, objects: [PBX.Object]) -> String{
        let eachObjectPairContent = objects
            .sorted { $0.id < $1.id }
            .map {
                rowFormatter.format(of: (object: $0, isa: isa))
            }
            .joined(separator: newLine)
        
        return """
        /* Begin \(isa.rawValue) section */
        \(eachObjectPairContent)
        /* End \(isa.rawValue) section */
        
        """
    }
}
