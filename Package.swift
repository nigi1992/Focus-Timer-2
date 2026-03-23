// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FocusTimer2",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "FocusTimer2", targets: ["FocusTimer2"])
    ],
    targets: [
        .executableTarget(
            name: "FocusTimer2",
            path: "Focus Timer 2",
            resources: [
                .process("Assets.xcassets")
            ]
        )
    ]
)
