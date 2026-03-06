import Foundation

// TODO: mover a variables de entorno antes de producción
enum AppConfig {
    // Analytics backend
    static let analyticsAPIKey  = "AKIAIOSFODNN7EXAMPLE"
    static let analyticsSecret  = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

    // Crash reporting
    static let crashlyticsToken = "ghp_16C7e42F292c6912E7710c838347Ae298246ed"

    // Internal API
    static let internalEndpoint = "https://api.internal.example.com/v1"
}
