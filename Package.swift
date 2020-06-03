// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Static",
    products: [
        .library(name: "Static", targets: ["Static"])
    ],
    targets: [
        .target(name: "Static"),
        .testTarget(name: "StaticTests", dependencies: ["Static"])
    ]
)
