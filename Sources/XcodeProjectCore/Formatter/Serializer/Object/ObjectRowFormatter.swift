//
//  ObjectRowFormatter.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/22.
//

import Foundation

public protocol ObjectRowFormatter {
    func format(context: Context) -> String
}


public struct ObjectRowFormatterImpl: ObjectRowFormatter {
    private let sectionFormatter: SectionFormatter
    public init(sectionFormatter: SectionFormatter = SectionFormatterImpl()) {
       self.sectionFormatter = sectionFormatter
    }
    
    public func format(context: Context) -> String {
        let groupedObject = context.objects
            .values
            .toArray()
            .groupBy { $0.isa.rawValue }
        let objectsContent = groupedObject
            .keys
            .sorted()
            .map { isa in
                return (ObjectType(for: isa), groupedObject[isa]!)
            }
            .map { isa, objects -> String in
                return sectionFormatter.format(context: context, isa: isa, objects: objects)
            }
            .joined(separator: newLine)
        return """
        \(indent)objects = {
        
        \(objectsContent)\(indent)};
        
        """
    }
}
