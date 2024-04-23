// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "zenea-swift-files",
    platforms: [
        .macOS("13.3")
    ],
    products: [
        .library(name: "zenea-files", targets: ["ZeneaFiles"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.64.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.3.0"),
        .package(url: "https://github.com/zenea-project/zenea-swift.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "ZeneaFiles",
            dependencies: [
                .product(name: "_NIOFileSystem", package: "swift-nio"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "zenea-swift", package: "zenea-swift")
            ],
            path: "./Sources/zenea-files"
        )
    ]
)
