// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PicsumFeature",
  platforms: [.iOS(.v18)],
  products: [
    .library(
      name: "PicsumFeature",
      targets: ["PicsumFeature"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .upToNextMajor(from: "1.17.1")
    ),
    .package(name: "RestAPIClient", path: "../RestAPIClient"),
    .package(name: "SharedModels", path: "../SharedModels")
  ],
  targets: [
    .target(
      name: "PicsumFeature",
      dependencies: [
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        ),
        .product(
          name: "RestAPIClient",
          package: "RestAPIClient"
        ),
        .product(
          name: "SharedModels",
          package: "SharedModels"
        ),
      ]
    ),
    .testTarget(
      name: "PicsumFeatureTests",
      dependencies: [
        "PicsumFeature"
      ]
    ),
  ]
)
