// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TIPSKit",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "TIPSKit",
            targets: ["TIPSKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/blastum/FetchKit.git", "1.0.0" ..< "1.1.0"),
//        .package(path: "../FetchKit"),
    ],
    targets: [
        .target(
            name: "TIPSKit",
            dependencies: [
                .product(name: "FetchKit", package: "FetchKit"),
            ]
        ),
        .testTarget(
            name: "TIPSKitTests",
            dependencies: ["TIPSKit"]
        ),
    ]
)
