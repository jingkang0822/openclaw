// swift-tools-version: 6.2
// Package manifest for the ClawX macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "ClawX",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "ClawXIPC", targets: ["ClawXIPC"]),
        .library(name: "ClawXDiscovery", targets: ["ClawXDiscovery"]),
        .executable(name: "ClawX", targets: ["ClawX"]),
        .executable(name: "clawx-mac", targets: ["ClawXMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/ClawXKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "ClawXIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "ClawXDiscovery",
            dependencies: [
                .product(name: "ClawXKit", package: "ClawXKit"),
            ],
            path: "Sources/ClawXDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "ClawX",
            dependencies: [
                "ClawXIPC",
                "ClawXDiscovery",
                .product(name: "ClawXKit", package: "ClawXKit"),
                .product(name: "ClawXChatUI", package: "ClawXKit"),
                .product(name: "ClawXProtocol", package: "ClawXKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/ClawX.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "ClawXMacCLI",
            dependencies: [
                "ClawXDiscovery",
                .product(name: "ClawXKit", package: "ClawXKit"),
                .product(name: "ClawXProtocol", package: "ClawXKit"),
            ],
            path: "Sources/ClawXMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "ClawXIPCTests",
            dependencies: [
                "ClawXIPC",
                "ClawX",
                "ClawXDiscovery",
                .product(name: "ClawXProtocol", package: "ClawXKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
