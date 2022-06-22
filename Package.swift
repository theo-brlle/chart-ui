// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ChartUI",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ChartUI",
            targets: ["ChartUI"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ChartUI",
            dependencies: []
        ),
        .testTarget(
            name: "ChartUITests",
            dependencies: ["ChartUI"]
        )
    ]
)
