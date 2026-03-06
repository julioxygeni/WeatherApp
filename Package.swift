// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WeatherApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "WeatherApp", targets: ["WeatherApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.4.2"),
        .package(url: "https://github.com/apple/swift-nio", exact: "2.61.0")
    ],
    targets: [
        .executableTarget(
            name: "WeatherApp",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "NIO", package: "swift-nio")
            ],
            path: "."
        )
    ]
)
