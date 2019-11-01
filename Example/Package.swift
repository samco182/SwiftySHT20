// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftySHT20Example",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/samco182/SwiftySHT20", from: "2.0.0-beta1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftySHT20Example",
            dependencies: ["SwiftySHT20"]),
        .testTarget(
            name: "SwiftySHT20ExampleTests",
            dependencies: ["SwiftySHT20Example"]),
    ]
)
