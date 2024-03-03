// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NetworkX",
    platforms: [.iOS(.v13), .macOS(.v11)],
    products: [
        .library(
            name: "NetworkX",
            targets: ["NetworkX"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NetworkX",
            dependencies: []
        )
    ]
)
