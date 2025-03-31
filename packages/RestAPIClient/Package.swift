// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RestAPIClient",
  platforms: [.iOS(.v18)],
  products: [
    .library(
      name: "RestAPIClient",
      targets: ["RestAPIClient"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .upToNextMajor(from: "1.17.1")
    ),
    .package(name: "SharedModels", path: "../SharedModels")
  ],
  targets: [
    .target(
      name: "RestAPIClient",
      dependencies: [ 
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        ),
        .product(
          name: "SharedModels",
          package: "SharedModels"
        ),
      ]
    ),
  ]
)
