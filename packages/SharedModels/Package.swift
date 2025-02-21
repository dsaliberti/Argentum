// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SharedModels",
  products: [
    .library(
      name: "SharedModels",
      targets: ["SharedModels"]),
  ],
  targets: [
    .target(
      name: "SharedModels"),
    .testTarget(
      name: "SharedModelsTests",
      dependencies: ["SharedModels"]
    ),
  ]
)
