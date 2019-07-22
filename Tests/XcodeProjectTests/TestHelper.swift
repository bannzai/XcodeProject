//
//  TestHelper.swift
//  XcodeProjectTests
//
//  Created by Yudai Hirose on 2019/07/10.
//

import Foundation
import XCTest
@testable import XcodeProject

func xcodeProjectUrl() -> URL {
    guard
        let testPath = ProcessInfo().environment["PBXProjectPath"],
        let url = URL(string: "file://" + testPath)
        else {
            XCTFail("Should set environment PBXProjectPath.")
            fatalError()
    }
    
    return url
}

func makeXcodeProject() -> XcodeProject {
    do {
        let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
        let project = XcodeProject(
            parser: parser,
            hashIDGenerator: PBXObjectHashIDGenerator()
        )
        return project
    } catch {
        XCTFail(error.localizedDescription)
        fatalError()
    }
}

func makeFieldFormatter() -> FieldListFormatterImpl {
    do {
        let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
        let project = XcodeProject(
            parser: parser,
            hashIDGenerator: PBXObjectHashIDGenerator()
        )
        return FieldListFormatterImpl(
            project: project,
            atomicValueFormatter: PBXAtomicValueFormatterImpl(project: project),
            valueListFormatter: PBXAtomicValueListFieldFormatterImpl(
                project: project,
                singlelineFormatter: SinglelinePBXAtomicValueListFieldFormatter(project: project),
                multilineFormatter: MultiplelinePBXAtomicValueListFieldFormatter(project: project)
            ),
            mapFormatter: PBXRawMapFormatterImpl(project: project),
            mapListFormatter: PBXRawMapListFormatterImpl(
                project: project
            )
        )
    } catch {
        XCTFail(error.localizedDescription)
        fatalError()
    }

}

func makeParserAndSerializer() -> (PBXProjectParser, XcodeProjectSerializer) {
    do {
        let parser = try PBXProjectParser(xcodeprojectUrl: xcodeProjectUrl())
        let project = XcodeProject(
            parser: parser,
            hashIDGenerator: PBXObjectHashIDGenerator()
        )
        let xcodeProjectFormatter = XcodeProjectFormatterImpl(
            objectRowFormatter: ObjectRowFormatterImpl(
                sectionFormatter: SectionFormatterImpl(
                    project: project,
                    rowFormatter: SectionRowFormatterImpl(
                        project: project,
                        fieldFormatter: FieldListFormatterImpl(
                            project: project,
                            atomicValueFormatter: PBXAtomicValueFormatterImpl(project: project),
                            valueListFormatter: PBXAtomicValueListFieldFormatterImpl(
                                project: project,
                                singlelineFormatter: SinglelinePBXAtomicValueListFieldFormatter(project: project),
                                multilineFormatter: MultiplelinePBXAtomicValueListFieldFormatter(project: project)
                            ),
                            mapFormatter: PBXRawMapFormatterImpl(project: project),
                            mapListFormatter: PBXRawMapListFormatterImpl(
                                project: project
                            )
                        )
                    )
                )
            ),
            otherRowFormatter: TopRowFormatterImpl(project: project)
        )
        let serializer = XcodeProjectSerializer(
            project: project,
            xcodeProjectFormatter: xcodeProjectFormatter
        )
        return (parser, serializer)
    } catch {
        XCTFail(error.localizedDescription)
        fatalError()
    }
}

extension Context {
    var grouped: [String: [PBX.Object]] {
        return self.objects
            .values
            .toArray()
            .groupBy { $0.isa.rawValue }
    }
}
