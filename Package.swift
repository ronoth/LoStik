// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoStik",
    products: [
        .library(
            name: "LoStik",
            targets: ["LoStik"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/MillerTechnologyPeru/SwiftSerial.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "LoStik",
            dependencies: ["SwiftSerial"]
        ),
        .testTarget(
            name: "LoStikTests",
            dependencies: ["LoStik"]
        ),
    ]
)
