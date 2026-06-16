// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorDocscanner",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapacitorDocscanner",
            targets: ["DocScannerPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "DocScannerPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/DocScannerPlugin"),
        .testTarget(
            name: "DocScannerPluginTests",
            dependencies: ["DocScannerPlugin"],
            path: "ios/Tests/DocScannerPluginTests")
    ]
)
