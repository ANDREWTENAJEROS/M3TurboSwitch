// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "M3TurboSwitch",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "M3TurboSwitchApp", targets: ["M3TurboSwitchApp"])
    ],
    targets: [
        .executableTarget(
            name: "M3TurboSwitchApp",
            path: "Sources/M3TurboSwitchApp"
        )
    ]
)
