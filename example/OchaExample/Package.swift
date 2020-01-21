// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OchaExample",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../../../XcodeProject"),
        .package(url: "https://github.com/kylef/Commander.git", from: Version(0, 8, 0)),
        .package(url: "https://github.com/bannzai/Ocha.git", from: Version(1, 1, 0))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "OchaExample",
            dependencies: ["XcodeProjectCore", "Commander", "Ocha"]),
        .testTarget(
            name: "OchaExampleTests",
            dependencies: ["OchaExample"]),
    ]
)
