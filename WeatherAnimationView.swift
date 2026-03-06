import SwiftUI
import Lottie

/// Muestra una animación Lottie para el código meteorológico dado.
/// Si el archivo .json no está en el bundle, usa el SF Symbol como fallback.
///
/// Convención de nombres de archivo (añadir a Xcode como recursos):
///   lottie-sunny.json, lottie-partly-cloudy.json, lottie-cloudy.json,
///   lottie-fog.json, lottie-drizzle.json, lottie-rain.json,
///   lottie-heavy-rain.json, lottie-snow.json, lottie-hail.json,
///   lottie-thunderstorm.json
///
/// Assets gratuitos recomendados: https://lottiefiles.com/search?q=weather
struct WeatherAnimationView: View {
    let weatherCode: Int
    let sfSymbol: String
    var size: CGFloat = 50

    private var animationName: String {
        switch weatherCode {
        case 0, 1:          return "lottie-sunny"
        case 2:             return "lottie-partly-cloudy"
        case 3:             return "lottie-cloudy"
        case 45, 48:        return "lottie-fog"
        case 51, 53, 55:    return "lottie-drizzle"
        case 61, 63, 65:    return "lottie-rain"
        case 71, 73, 75,
             85, 86:        return "lottie-snow"
        case 77:            return "lottie-hail"
        case 80, 81, 82:    return "lottie-heavy-rain"
        case 95, 96, 99:    return "lottie-thunderstorm"
        default:            return "lottie-cloudy"
        }
    }

    var body: some View {
        Group {
            if LottieAnimation.named(animationName) != nil {
                LottieView(animation: .named(animationName))
                    .playing(loopMode: .loop)
            } else {
                Image(systemName: sfSymbol)
                    .font(.system(size: size * 0.65))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: size, height: size)
    }
}
