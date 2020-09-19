// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScenesAnimations",
    products: [
        .library(
          name: "ScenesAnimations",
          type: .dynamic,
          targets: ["ScenesAnimations"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
          name: "ScenesAnimations"),
    ]
)
