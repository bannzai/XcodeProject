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

@testable import XcodeProjectCore














class FieldFormatterMock: FieldFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatContextOfForCallsCount = 0
    var formatContextOfForCalled: Bool {
        return formatContextOfForCallsCount > 0
    }
    var formatContextOfForReceivedArguments: (context: Context, info: FieldFormatterInfomation, level: Int)?
    var formatContextOfForReturnValue: String!
    var formatContextOfForClosure: ((Context, FieldFormatterInfomation, Int) -> String)?

    func format(context: Context, of info: FieldFormatterInfomation, for level: Int) -> String {
        methodCalledStack.append("format(context:of:for:)")
        formatContextOfForCallsCount += 1
        formatContextOfForReceivedArguments = (context: context, info: info, level: level)
        return formatContextOfForClosure.map({ $0(context, info, level) }) ?? formatContextOfForReturnValue
    }

}
class FileSystemWriterMock: FileSystemWriter {
    var methodCalledStack: [String] = []


    //MARK: - move

    var moveSourceDestinationThrowableError: Error?
    var moveSourceDestinationCallsCount = 0
    var moveSourceDestinationCalled: Bool {
        return moveSourceDestinationCallsCount > 0
    }
    var moveSourceDestinationReceivedArguments: (source: String, destination: String)?
    var moveSourceDestinationClosure: ((String, String) throws -> Void)?

    func move(source: String, destination: String) throws {
        methodCalledStack.append("move(source:destination:)")
        if let error = moveSourceDestinationThrowableError {
            throw error
        }
        moveSourceDestinationCallsCount += 1
        moveSourceDestinationReceivedArguments = (source: source, destination: destination)
        try moveSourceDestinationClosure?(source, destination)
    }

    //MARK: - createDirectory

    var createDirectoryPathThrowableError: Error?
    var createDirectoryPathCallsCount = 0
    var createDirectoryPathCalled: Bool {
        return createDirectoryPathCallsCount > 0
    }
    var createDirectoryPathReceivedPath: String?
    var createDirectoryPathClosure: ((String) throws -> Void)?

    func createDirectory(path: String) throws {
        methodCalledStack.append("createDirectory(path:)")
        if let error = createDirectoryPathThrowableError {
            throw error
        }
        createDirectoryPathCallsCount += 1
        createDirectoryPathReceivedPath = path
        try createDirectoryPathClosure?(path)
    }

    //MARK: - remove

    var removePathThrowableError: Error?
    var removePathCallsCount = 0
    var removePathCalled: Bool {
        return removePathCallsCount > 0
    }
    var removePathReceivedPath: String?
    var removePathClosure: ((String) throws -> Void)?

    func remove(path: String) throws {
        methodCalledStack.append("remove(path:)")
        if let error = removePathThrowableError {
            throw error
        }
        removePathCallsCount += 1
        removePathReceivedPath = path
        try removePathClosure?(path)
    }

    //MARK: - isExistsFile

    var isExistsFilePathCallsCount = 0
    var isExistsFilePathCalled: Bool {
        return isExistsFilePathCallsCount > 0
    }
    var isExistsFilePathReceivedPath: String?
    var isExistsFilePathReturnValue: Bool!
    var isExistsFilePathClosure: ((String) -> Bool)?

    func isExistsFile(path: String) -> Bool {
        methodCalledStack.append("isExistsFile(path:)")
        isExistsFilePathCallsCount += 1
        isExistsFilePathReceivedPath = path
        return isExistsFilePathClosure.map({ $0(path) }) ?? isExistsFilePathReturnValue
    }

    //MARK: - isExistsDirectory

    var isExistsDirectoryPathCallsCount = 0
    var isExistsDirectoryPathCalled: Bool {
        return isExistsDirectoryPathCallsCount > 0
    }
    var isExistsDirectoryPathReceivedPath: String?
    var isExistsDirectoryPathReturnValue: Bool!
    var isExistsDirectoryPathClosure: ((String) -> Bool)?

    func isExistsDirectory(path: String) -> Bool {
        methodCalledStack.append("isExistsDirectory(path:)")
        isExistsDirectoryPathCallsCount += 1
        isExistsDirectoryPathReceivedPath = path
        return isExistsDirectoryPathClosure.map({ $0(path) }) ?? isExistsDirectoryPathReturnValue
    }

}
class PBXAtomicValueFormatterMock: PBXAtomicValueFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatContextOfInCallsCount = 0
    var formatContextOfInCalled: Bool {
        return formatContextOfInCallsCount > 0
    }
    var formatContextOfInReceivedArguments: (context: Context, info: PBXAtomicValueFormatterInformation, level: Int)?
    var formatContextOfInReturnValue: String!
    var formatContextOfInClosure: ((Context, PBXAtomicValueFormatterInformation, Int) -> String)?

    func format(context: Context, of info: PBXAtomicValueFormatterInformation, in level: Int) -> String {
        methodCalledStack.append("format(context:of:in:)")
        formatContextOfInCallsCount += 1
        formatContextOfInReceivedArguments = (context: context, info: info, level: level)
        return formatContextOfInClosure.map({ $0(context, info, level) }) ?? formatContextOfInReturnValue
    }

}
class PBXAtomicValueListFieldFormatterMock: PBXAtomicValueListFieldFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatContextOfForCallsCount = 0
    var formatContextOfForCalled: Bool {
        return formatContextOfForCallsCount > 0
    }
    var formatContextOfForReceivedArguments: (context: Context, info: PBXAtomicValueListFieldFormatterInfomation, level: Int)?
    var formatContextOfForReturnValue: String!
    var formatContextOfForClosure: ((Context, PBXAtomicValueListFieldFormatterInfomation, Int) -> String)?

    func format(context: Context, of info: PBXAtomicValueListFieldFormatterInfomation, for level: Int) -> String {
        methodCalledStack.append("format(context:of:for:)")
        formatContextOfForCallsCount += 1
        formatContextOfForReceivedArguments = (context: context, info: info, level: level)
        return formatContextOfForClosure.map({ $0(context, info, level) }) ?? formatContextOfForReturnValue
    }

}
class PBXAtomicValueListFieldFormatterComponentMock: PBXAtomicValueListFieldFormatterComponent {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatContextOfLevelCallsCount = 0
    var formatContextOfLevelCalled: Bool {
        return formatContextOfLevelCallsCount > 0
    }
    var formatContextOfLevelReceivedArguments: (context: Context, info: (key: String, objectIds: [PBXObjectIDType]), level: Int)?
    var formatContextOfLevelReturnValue: String!
    var formatContextOfLevelClosure: ((Context, (key: String, objectIds: [PBXObjectIDType]), Int) -> String)?

    func format(context: Context, of info: (key: String, objectIds: [PBXObjectIDType]), level: Int) -> String {
        methodCalledStack.append("format(context:of:level:)")
        formatContextOfLevelCallsCount += 1
        formatContextOfLevelReceivedArguments = (context: context, info: info, level: level)
        return formatContextOfLevelClosure.map({ $0(context, info, level) }) ?? formatContextOfLevelReturnValue
    }

}
class PBXRawMapFormatterMock: PBXRawMapFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatContextOfInNextCallsCount = 0
    var formatContextOfInNextCalled: Bool {
        return formatContextOfInNextCallsCount > 0
    }
    var formatContextOfInNextReceivedArguments: (context: Context, info: PBXRawMapFormatterInformation, level: Int, nextFormatter: FieldFormatter)?
    var formatContextOfInNextReturnValue: String!
    var formatContextOfInNextClosure: ((Context, PBXRawMapFormatterInformation, Int, FieldFormatter) -> String)?

    func format(        context: Context,        of info: PBXRawMapFormatterInformation,        in level: Int,        next nextFormatter: FieldFormatter        ) -> String {
        methodCalledStack.append("format(context:of:in:next:)")
        formatContextOfInNextCallsCount += 1
        formatContextOfInNextReceivedArguments = (context: context, info: info, level: level, nextFormatter: nextFormatter)
        return formatContextOfInNextClosure.map({ $0(context, info, level, nextFormatter) }) ?? formatContextOfInNextReturnValue
    }

}
class PBXRawMapListFormatterMock: PBXRawMapListFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatContextOfInNextCallsCount = 0
    var formatContextOfInNextCalled: Bool {
        return formatContextOfInNextCallsCount > 0
    }
    var formatContextOfInNextReceivedArguments: (context: Context, info: PBXRawMapListFormatterInformation, level: Int, nextFormatter: FieldFormatter)?
    var formatContextOfInNextReturnValue: String!
    var formatContextOfInNextClosure: ((Context, PBXRawMapListFormatterInformation, Int, FieldFormatter) -> String)?

    func format(        context: Context,        of info: PBXRawMapListFormatterInformation,        in level: Int,        next nextFormatter: FieldFormatter    ) -> String {
        methodCalledStack.append("format(context:of:in:next:)")
        formatContextOfInNextCallsCount += 1
        formatContextOfInNextReceivedArguments = (context: context, info: info, level: level, nextFormatter: nextFormatter)
        return formatContextOfInNextClosure.map({ $0(context, info, level, nextFormatter) }) ?? formatContextOfInNextReturnValue
    }

}
class ResourcesBuildPhaseExtractorMock: ResourcesBuildPhaseExtractor {
    var methodCalledStack: [String] = []

    var targetExtractor: NativeTargetExtractor {
        get { return underlyingTargetExtractor }
        set(value) { underlyingTargetExtractor = value }
    }
    var underlyingTargetExtractor: NativeTargetExtractor!

    //MARK: - extract

    var extractContextTargetNameCallsCount = 0
    var extractContextTargetNameCalled: Bool {
        return extractContextTargetNameCallsCount > 0
    }
    var extractContextTargetNameReceivedArguments: (context: Context, targetName: String)?
    var extractContextTargetNameReturnValue: PBX.ResourcesBuildPhase?
    var extractContextTargetNameClosure: ((Context, String) -> PBX.ResourcesBuildPhase?)?

    func extract(context: Context, targetName: String) -> PBX.ResourcesBuildPhase? {
        methodCalledStack.append("extract(context:targetName:)")
        extractContextTargetNameCallsCount += 1
        extractContextTargetNameReceivedArguments = (context: context, targetName: targetName)
        return extractContextTargetNameClosure.map({ $0(context, targetName) }) ?? extractContextTargetNameReturnValue
    }

}
class SectionFormatterMock: SectionFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatContextIsaObjectsCallsCount = 0
    var formatContextIsaObjectsCalled: Bool {
        return formatContextIsaObjectsCallsCount > 0
    }
    var formatContextIsaObjectsReceivedArguments: (context: Context, isa: ObjectType, objects: [PBX.Object])?
    var formatContextIsaObjectsReturnValue: String!
    var formatContextIsaObjectsClosure: ((Context, ObjectType, [PBX.Object]) -> String)?

    func format(context: Context, isa: ObjectType, objects: [PBX.Object]) -> String {
        methodCalledStack.append("format(context:isa:objects:)")
        formatContextIsaObjectsCallsCount += 1
        formatContextIsaObjectsReceivedArguments = (context: context, isa: isa, objects: objects)
        return formatContextIsaObjectsClosure.map({ $0(context, isa, objects) }) ?? formatContextIsaObjectsReturnValue
    }

}
class SectionRowFormatterMock: SectionRowFormatter {
    var methodCalledStack: [String] = []


    //MARK: - format

    var formatContextOfCallsCount = 0
    var formatContextOfCalled: Bool {
        return formatContextOfCallsCount > 0
    }
    var formatContextOfReceivedArguments: (context: Context, info: SectionRowFormatterInformation)?
    var formatContextOfReturnValue: String!
    var formatContextOfClosure: ((Context, SectionRowFormatterInformation) -> String)?

    func format(context: Context, of info: SectionRowFormatterInformation) -> String {
        methodCalledStack.append("format(context:of:)")
        formatContextOfCallsCount += 1
        formatContextOfReceivedArguments = (context: context, info: info)
        return formatContextOfClosure.map({ $0(context, info) }) ?? formatContextOfReturnValue
    }

}
class SerializeFormatterMock: SerializeFormatter {
    var methodCalledStack: [String] = []


}
class SourcesBuildPhaseExtractorMock: SourcesBuildPhaseExtractor {
    var methodCalledStack: [String] = []

    var targetExtractor: NativeTargetExtractor {
        get { return underlyingTargetExtractor }
        set(value) { underlyingTargetExtractor = value }
    }
    var underlyingTargetExtractor: NativeTargetExtractor!

    //MARK: - extract

    var extractContextTargetNameCallsCount = 0
    var extractContextTargetNameCalled: Bool {
        return extractContextTargetNameCallsCount > 0
    }
    var extractContextTargetNameReceivedArguments: (context: Context, targetName: String)?
    var extractContextTargetNameReturnValue: PBX.SourcesBuildPhase?
    var extractContextTargetNameClosure: ((Context, String) -> PBX.SourcesBuildPhase?)?

    func extract(context: Context, targetName: String) -> PBX.SourcesBuildPhase? {
        methodCalledStack.append("extract(context:targetName:)")
        extractContextTargetNameCallsCount += 1
        extractContextTargetNameReceivedArguments = (context: context, targetName: targetName)
        return extractContextTargetNameClosure.map({ $0(context, targetName) }) ?? extractContextTargetNameReturnValue
    }

}
class StringGeneratorMock: StringGenerator {
    var methodCalledStack: [String] = []


    //MARK: - generate

    var generateCallsCount = 0
    var generateCalled: Bool {
        return generateCallsCount > 0
    }
    var generateReturnValue: String!
    var generateClosure: (() -> String)?

    func generate() -> String {
        methodCalledStack.append("generate")
        generateCallsCount += 1
        return generateClosure.map({ $0() }) ?? generateReturnValue
    }

}
