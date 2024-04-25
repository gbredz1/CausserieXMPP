// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CauserieXMPP",
    platforms: [
        .iOS(.v14),
        .macOS(SupportedPlatform.MacOSVersion.v12),
    ],
    products: [
        .library(
            name: "CauserieXMPP",
            targets: ["CauserieXMPP"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", .upToNextMajor(from: "2.3.1")),
        .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.54.0")),
    ],
    targets: [
        .target(
            name: "CauserieXMPP",
            dependencies: [
                .product(name: "Factory", package: "factory")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "CauserieXMPPTests",
            dependencies: [
                "CauserieXMPP"
            ],
            resources: [
                .copy("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
    ]
)
