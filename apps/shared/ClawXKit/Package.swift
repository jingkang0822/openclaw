// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "ClawXKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "ClawXProtocol", targets: ["ClawXProtocol"]),
        .library(name: "ClawXKit", targets: ["ClawXKit"]),
        .library(name: "ClawXChatUI", targets: ["ClawXChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "ClawXProtocol",
            path: "Sources/ClawXProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "ClawXKit",
            dependencies: [
                "ClawXProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/ClawXKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "ClawXChatUI",
            dependencies: [
                "ClawXKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/ClawXChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "ClawXKitTests",
            dependencies: ["ClawXKit", "ClawXChatUI"],
            path: "Tests/ClawXKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
