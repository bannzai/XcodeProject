// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodeProject",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "xcp", targets: ["XcodeProject"]),
        .library(
            name: "XcodeProjectCore",
            targets: ["XcodeProjectCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/bannzai/Swdifft.git", from: Version(1, 0, 3)),
         .package(url: "https://github.com/jakeheis/SwiftCLI.git", .exact("5.2.2")),
         .package(url: "https://github.com/kareman/SwiftShell.git", .exact("5.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "XcodeProject",
            dependencies: ["XcodeProjectCLI"]),
        .target(
            name: "XcodeProjectCLI",
            dependencies: ["XcodeProjectCore", "SwiftCLI", "SwiftShell"]),
        .target(
            name: "XcodeProjectCore",
            dependencies: ["Swdifft"]),
        .testTarget(
            name: "XcodeProjectCoreTests",
            dependencies: ["XcodeProjectCore", "Swdifft"]),
    ]
)
