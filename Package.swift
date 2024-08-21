// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorDocscanner",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapacitorDocscanner",
            targets: ["DocScannerPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "DocScannerPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/DocScannerPlugin"),
        .testTarget(
            name: "DocScannerPluginTests",
            dependencies: ["DocScannerPlugin"],
            path: "ios/Tests/DocScannerPluginTests")
    ]
)