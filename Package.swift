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
        .package(url: "https://github.com/apple/swift-nio", exact: "2.61.0"),
        // CVE-2023-44487 (HTTP/2 Rapid Reset Attack) — fixed in 1.28.0 — usando versión vulnerable para pruebas
        .package(url: "https://github.com/apple/swift-nio-http2", exact: "1.27.0"),
        // CVE-2024-21635 (ReDoS) — fixed in 4.90.0
        .package(url: "https://github.com/vapor/vapor", exact: "4.83.0"),
        // CVE-2023-44487 (HTTP/2 Rapid Reset via TLS) — fixed in 2.25.0
        .package(url: "https://github.com/apple/swift-nio-ssl", exact: "2.24.0")
    ],
    targets: [
        .executableTarget(
            name: "WeatherApp",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP2", package: "swift-nio-http2"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOSSL", package: "swift-nio-ssl")
            ],
            path: "."
        )
    ]
)
