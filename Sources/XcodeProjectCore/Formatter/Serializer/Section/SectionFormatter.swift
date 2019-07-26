//
//  SectionFormatter.swift
//  XcodeProject
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public protocol SectionFormatter: SerializeFormatter {
    func format(context: Context, isa: ObjectType, objects: [PBX.Object]) -> String
}

public struct SectionFormatterImpl: SectionFormatter {
    private let rowFormatter: SectionRowFormatter
    public init(
        rowFormatter: SectionRowFormatter = SectionRowFormatterImpl()
        ) {
        self.rowFormatter = rowFormatter
    }
    
    public func format(context: Context, isa: ObjectType, objects: [PBX.Object]) -> String{
        let eachObjectPairContent = objects
            .sorted { $0.id < $1.id }
            .map {
                rowFormatter.format(context: context, of: (object: $0, isa: isa))
            }
            .joined(separator: newLine)
        
        return """
        /* Begin \(isa.rawValue) section */
        \(eachObjectPairContent)
        /* End \(isa.rawValue) section */
        
        """
    }
}
