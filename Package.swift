// swift-tools-version: 5.10.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UMLSClient",
  platforms: [.iOS(.v13), .macOS(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "UMLSClient",
      targets: ["UMLSClient"])
  ],
  dependencies: [
    .package(url: "https://github.com/karwa/swift-url", .upToNextMinor(from: "0.4.0")),
    .package(url: "https://github.com/aniketnarvekar/UMLSClientModel.git", from: .init(0, 0, 1)),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "UMLSClient",
      dependencies: [
        .product(name: "WebURL", package: "swift-url"),
        .product(name: "UMLSClientModel", package: "UMLSClientModel"),
      ]),
    .testTarget(
      name: "UMLSClientTests",
      dependencies: [
        "UMLSClient", .product(name: "WebURL", package: "swift-url"),
        .product(name: "Random", package: "UMLSClientModel"),
      ],
      resources: [
        .process("Stubs/")
      ]),
  ]
)
