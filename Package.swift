// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VCModifier",
    platforms: [.iOS(.v13), .tvOS(.v13)],
    products: [
        .library(name: "VCModifier", targets: ["VCModifier"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "VCModifier", dependencies: []),
    ]
)
