// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ColorGenerator",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
        .macOS(.v13)
    ],
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "ColorGeneratorPlugin",
            targets: ["ColorGeneratorPlugin"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "ColorGeneratorPlugin",
            capability: .buildTool(),
            dependencies: ["ColorGeneratorExec"]
        ),
        .executableTarget(
            name: "ColorGeneratorExec",
            path: "Sources/ColorGeneratorExec"
        )
    ]
)
