// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "APOSDesignSystem",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "APOSDesignSystem",
            targets: ["APOSDesignSystem"]
        )
    ],
    targets: [
        .target(
            name: "APOSDesignSystem"
        ),
        .testTarget(
            name: "APOSDesignSystemTests",
            dependencies: ["APOSDesignSystem"]
        )
    ]
)
