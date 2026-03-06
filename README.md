# WeatherApp

Aplicación iOS/macOS en SwiftUI que muestra el pronóstico meteorológico de 7 días usando la API pública de [Open-Meteo](https://open-meteo.com/) (sin API key).

## Características

- Pronóstico de 7 días en °C
- Selección de ciudad desde un menú desplegable
- Gestión de ciudades (añadir, eliminar, reordenar) desde Ajustes
- Búsqueda de ciudades con geocoding
- Animaciones Lottie con fallback a SF Symbols
- Persistencia con UserDefaults
- Interfaz en español

## Requisitos

- macOS 14+ / iOS 17+
- Xcode 15+
- Swift 5.9+

## Instalación

```bash
git clone <repo>
cd WeatherApp
swift build
```

O abre `Package.swift` directamente en Xcode.

## Animaciones Lottie

Descarga los assets en [lottiefiles.com](https://lottiefiles.com) y añádelos al target con estos nombres:

| Archivo | Condición |
|---|---|
| `lottie-sunny.json` | Despejado |
| `lottie-partly-cloudy.json` | Parcialmente nublado |
| `lottie-cloudy.json` | Nublado |
| `lottie-fog.json` | Niebla |
| `lottie-drizzle.json` | Llovizna |
| `lottie-rain.json` | Lluvia |
| `lottie-heavy-rain.json` | Chubascos |
| `lottie-snow.json` | Nieve |
| `lottie-hail.json` | Granizo |
| `lottie-thunderstorm.json` | Tormenta |

## APIs utilizadas

- **Geocoding:** `https://geocoding-api.open-meteo.com/v1/search`
- **Forecast:** `https://api.open-meteo.com/v1/forecast`

## Dependencias

| Paquete | Versión | Uso |
|---|---|---|
| [lottie-spm](https://github.com/airbnb/lottie-ios) | ≥ 4.4.2 | Animaciones de clima |
| [swift-nio](https://github.com/apple/swift-nio) | 2.61.0 | Networking |
