// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodeProject",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "XcodeProjectCore",
            targets: ["XcodeProjectCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/bannzai/Swdifft.git", from: Version(1, 0, 3)),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        Target.target(
            name: "XcodeProjectCore",
            dependencies: ["Swdifft"],
            exclude: [
                "Sources/XcodeProjectCore/Appender/Component/Tests", 
                "Sources/XcodeProjectCore/Xcode/Tests",
                "Sources/XcodeProjectCore/Serializer/Tests",
                "Sources/XcodeProjectCore/Parser/Tests",
                "Sources/XcodeProjectCore/Extractor/Tests",
        ]),
        Target.testTarget(
            name: "XcodeProjectAppenderComponentTests",
            dependencies: ["XcodeProjectCore", "Swdifft"],
            path: "Sources/XcodeProjectCore/Appender/Component/Tests"),
        Target.testTarget(
            name: "XcodeProjectCoreXcodeProjectTests",
            dependencies: ["XcodeProjectCore", "Swdifft"],
            path: "Sources/XcodeProjectCore/Xcode/Tests"),
        Target.testTarget(
            name: "XcodeProjectSerializerTests",
            dependencies: ["XcodeProjectCore", "Swdifft"],
            path: "Sources/XcodeProjectCore/Serializer/Tests"),
        Target.testTarget(
            name: "XcodeProjectParserTests",
            dependencies: ["XcodeProjectCore", "Swdifft"],
            path: "Sources/XcodeProjectCore/Parser/Tests"),
        Target.testTarget(
            name: "XcodeProjectExtractorTests",
            dependencies: ["XcodeProjectCore", "Swdifft"],
            path: "Sources/XcodeProjectCore/Extractor/Tests"),
        .testTarget(
            name: "XcodeProjectCoreTests",
            dependencies: ["XcodeProjectCore", "Swdifft"]),
    ]
)
