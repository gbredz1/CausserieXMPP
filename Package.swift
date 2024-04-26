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
        //        .package(url: "https://github.com/CoreOffice/XMLCoder.git", .upToNextMajor(from: "0.15.0")),
    ],
    targets: [
        .target(
            name: "CauserieXMPP",
            dependencies: [
                .product(name: "Factory", package: "factory")
                //                .product(name: "XMLCoder", package: "XMLCoder"),
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "CauserieXMPP-UnitTests",
            dependencies: [
                "CauserieXMPP"
            ],
            path: "Tests/UnitTests",
            resources: [
                .copy("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "CauserieXMPP-IntegrationTests",
            dependencies: [
                "CauserieXMPP"
            ],
            path: "Tests/IntegrationTests",
            resources: [
                .copy("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
    ]
)
