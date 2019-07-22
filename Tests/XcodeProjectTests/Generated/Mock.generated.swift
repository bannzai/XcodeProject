// Generated using Sourcery 0.16.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

@testable import XcodeProject














class FieldFormatterMock: FieldFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatOfForCallsCount = 0
    var formatOfForCalled: Bool {
        return formatOfForCallsCount > 0
    }
    var formatOfForReceivedArguments: (info: FieldFormatterInfomation, level: Int)?
    var formatOfForReturnValue: String!
    var formatOfForClosure: ((FieldFormatterInfomation, Int) -> String)?

    func format(of info: FieldFormatterInfomation, for level: Int) -> String {
        methodCalledStack.append("format(of:for:)")
        formatOfForCallsCount += 1
        formatOfForReceivedArguments = (info: info, level: level)
        return formatOfForClosure.map({ $0(info, level) }) ?? formatOfForReturnValue
    }

}
class PBXAtomicValueFormatterMock: PBXAtomicValueFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatOfInCallsCount = 0
    var formatOfInCalled: Bool {
        return formatOfInCallsCount > 0
    }
    var formatOfInReceivedArguments: (info: PBXAtomicValueFormatterInformation, level: Int)?
    var formatOfInReturnValue: String!
    var formatOfInClosure: ((PBXAtomicValueFormatterInformation, Int) -> String)?

    func format(of info: PBXAtomicValueFormatterInformation, in level: Int) -> String {
        methodCalledStack.append("format(of:in:)")
        formatOfInCallsCount += 1
        formatOfInReceivedArguments = (info: info, level: level)
        return formatOfInClosure.map({ $0(info, level) }) ?? formatOfInReturnValue
    }

}
class PBXAtomicValueListFieldFormatterMock: PBXAtomicValueListFieldFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatOfForCallsCount = 0
    var formatOfForCalled: Bool {
        return formatOfForCallsCount > 0
    }
    var formatOfForReceivedArguments: (info: PBXAtomicValueListFieldFormatterInfomation, level: Int)?
    var formatOfForReturnValue: String!
    var formatOfForClosure: ((PBXAtomicValueListFieldFormatterInfomation, Int) -> String)?

    func format(of info: PBXAtomicValueListFieldFormatterInfomation, for level: Int) -> String {
        methodCalledStack.append("format(of:for:)")
        formatOfForCallsCount += 1
        formatOfForReceivedArguments = (info: info, level: level)
        return formatOfForClosure.map({ $0(info, level) }) ?? formatOfForReturnValue
    }

}
class PBXAtomicValueListFieldFormatterComponentMock: PBXAtomicValueListFieldFormatterComponent {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatOfLevelCallsCount = 0
    var formatOfLevelCalled: Bool {
        return formatOfLevelCallsCount > 0
    }
    var formatOfLevelReceivedArguments: (info: (key: String, objectIds: [PBXObjectIDType]), level: Int)?
    var formatOfLevelReturnValue: String!
    var formatOfLevelClosure: (((key: String, objectIds: [PBXObjectIDType]), Int) -> String)?

    func format(of info: (key: String, objectIds: [PBXObjectIDType]), level: Int) -> String {
        methodCalledStack.append("format(of:level:)")
        formatOfLevelCallsCount += 1
        formatOfLevelReceivedArguments = (info: info, level: level)
        return formatOfLevelClosure.map({ $0(info, level) }) ?? formatOfLevelReturnValue
    }

}
class PBXRawMapFormatterMock: PBXRawMapFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatOfInNextCallsCount = 0
    var formatOfInNextCalled: Bool {
        return formatOfInNextCallsCount > 0
    }
    var formatOfInNextReceivedArguments: (info: PBXRawMapFormatterInformation, level: Int, nextFormatter: FieldFormatter)?
    var formatOfInNextReturnValue: String!
    var formatOfInNextClosure: ((PBXRawMapFormatterInformation, Int, FieldFormatter) -> String)?

    func format(        of info: PBXRawMapFormatterInformation,        in level: Int,        next nextFormatter: FieldFormatter        ) -> String {
        methodCalledStack.append("format(of:in:next:)")
        formatOfInNextCallsCount += 1
        formatOfInNextReceivedArguments = (info: info, level: level, nextFormatter: nextFormatter)
        return formatOfInNextClosure.map({ $0(info, level, nextFormatter) }) ?? formatOfInNextReturnValue
    }

}
class PBXRawMapListFormatterMock: PBXRawMapListFormatter {
    var methodCalledStack: [String] = []

    var project: XcodeProject {
        get { return underlyingProject }
        set(value) { underlyingProject = value }
    }
    var underlyingProject: XcodeProject!

    //MARK: - format

    var formatOfInNextCallsCount = 0
    var formatOfInNextCalled: Bool {
        return formatOfInNextCallsCount > 0
    }
    var formatOfInNextReceivedArguments: (info: PBXRawMapListFormatterInformation, level: Int, nextFormatter: FieldFormatter)?
    var formatOfInNextReturnValue: String!
    var formatOfInNextClosure: ((PBXRawMapListFormatterInformation, Int, FieldFormatter) -> String)?

    func format(        of info: PBXRawMapListFormatterInformation,        in level: Int,        next nextFormatter: FieldFormatter    ) -> String {
        methodCalledStack.append("format(of:in:next:)")
        formatOfInNextCallsCount += 1
        formatOfInNextReceivedArguments = (info: info, level: level, nextFormatter: nextFormatter)
        return formatOfInNextClosure.map({ $0(info, level, nextFormatter) }) ?? formatOfInNextReturnValue
    }

}
class SectionFormatterMock: SectionFormatter {
    var methodCalledStack: [String] = []

    var project: XcodeProject {
        get { return underlyingProject }
        set(value) { underlyingProject = value }
    }
    var underlyingProject: XcodeProject!

    //MARK: - format

    var formatIsaObjectsCallsCount = 0
    var formatIsaObjectsCalled: Bool {
        return formatIsaObjectsCallsCount > 0
    }
    var formatIsaObjectsReceivedArguments: (isa: ObjectType, objects: [PBX.Object])?
    var formatIsaObjectsReturnValue: String!
    var formatIsaObjectsClosure: ((ObjectType, [PBX.Object]) -> String)?

    func format(isa: ObjectType, objects: [PBX.Object]) -> String {
        methodCalledStack.append("format(isa:objects:)")
        formatIsaObjectsCallsCount += 1
        formatIsaObjectsReceivedArguments = (isa: isa, objects: objects)
        return formatIsaObjectsClosure.map({ $0(isa, objects) }) ?? formatIsaObjectsReturnValue
    }

}
class SectionRowFormatterMock: SectionRowFormatter {
    var methodCalledStack: [String] = []

    var project: XcodeProject {
        get { return underlyingProject }
        set(value) { underlyingProject = value }
    }
    var underlyingProject: XcodeProject!

    //MARK: - format

    var formatOfCallsCount = 0
    var formatOfCalled: Bool {
        return formatOfCallsCount > 0
    }
    var formatOfReceivedInfo: SectionRowFormatterInformation?
    var formatOfReturnValue: String!
    var formatOfClosure: ((SectionRowFormatterInformation) -> String)?

    func format(of info: SectionRowFormatterInformation) -> String {
        methodCalledStack.append("format(of:)")
        formatOfCallsCount += 1
        formatOfReceivedInfo = info
        return formatOfClosure.map({ $0(info) }) ?? formatOfReturnValue
    }

}
class SerializeFormatterMock: SerializeFormatter {
    var methodCalledStack: [String] = []

    var project: XcodeProject {
        get { return underlyingProject }
        set(value) { underlyingProject = value }
    }
    var underlyingProject: XcodeProject!

}
