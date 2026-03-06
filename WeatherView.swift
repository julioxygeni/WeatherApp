import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var cityStore: CityStore

    @State private var forecasts: [DayForecast] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    private var gradientColors: [Color] {
        guard let first = forecasts.first else {
            return [Color(red: 0.28, green: 0.45, blue: 0.70), Color(red: 0.18, green: 0.32, blue: 0.55)]
        }
        switch first.weatherCode {
        case 0, 1:
            return [Color(red: 0.22, green: 0.60, blue: 0.92), Color(red: 0.10, green: 0.40, blue: 0.75)]
        case 2, 3:
            return [Color(red: 0.45, green: 0.55, blue: 0.70), Color(red: 0.30, green: 0.40, blue: 0.55)]
        case 45, 48, 51...65:
            return [Color(red: 0.40, green: 0.50, blue: 0.60), Color(red: 0.25, green: 0.35, blue: 0.45)]
        case 71...77:
            return [Color(red: 0.60, green: 0.70, blue: 0.80), Color(red: 0.45, green: 0.55, blue: 0.68)]
        case 95, 96, 99:
            return [Color(red: 0.20, green: 0.25, blue: 0.35), Color(red: 0.12, green: 0.15, blue: 0.25)]
        default:
            return [Color(red: 0.28, green: 0.45, blue: 0.70), Color(red: 0.18, green: 0.32, blue: 0.55)]
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    cityPickerMenu
                        .padding(.top, 8)

                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if let error = errorMessage {
                        ContentUnavailableView(
                            "No se pudo cargar",
                            systemImage: "wifi.slash",
                            description: Text(error)
                        )
                        .foregroundStyle(.white)
                    } else if forecasts.isEmpty {
                        ContentUnavailableView(
                            "Sin datos",
                            systemImage: "cloud.slash",
                            description: Text("Selecciona una ciudad para ver el pronóstico")
                        )
                        .foregroundStyle(.white)
                    } else {
                        if let today = forecasts.first {
                            todayCard(today)
                        }
                        weeklyForecastSection
                    }
                }
                .padding()
            }
        }
        .task(id: cityStore.selectedCity?.id) {
            await loadForecast()
        }
    }

    // MARK: - Subviews

    private var cityPickerMenu: some View {
        Menu {
            ForEach(cityStore.cities) { city in
                Button {
                    cityStore.select(city)
                } label: {
                    HStack {
                        Text(city.name)
                        if city.id == cityStore.selectedCity?.id {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 6) {
                Text(cityStore.selectedCity?.name ?? "Seleccionar ciudad")
                    .font(.title2)
                    .fontWeight(.semibold)
                Image(systemName: "chevron.down")
                    .font(.subheadline)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
        }
    }

    private func todayCard(_ forecast: DayForecast) -> some View {
        VStack(spacing: 12) {
            Text("Hoy")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))

            WeatherAnimationView(
                weatherCode: forecast.weatherCode,
                sfSymbol: forecast.weatherSymbol,
                size: 90
            )
            .shadow(radius: 4)

            Text(forecast.weatherDescription)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.9))

            HStack(spacing: 24) {
                VStack {
                    Text("Máx")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    Text("\(Int(forecast.maxTemp))°")
                        .font(.system(size: 44, weight: .thin))
                        .foregroundStyle(.white)
                }
                VStack {
                    Text("Mín")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    Text("\(Int(forecast.minTemp))°")
                        .font(.system(size: 44, weight: .thin))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    private var weeklyForecastSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Próximos 7 días")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                ForEach(Array(forecasts.enumerated()), id: \.element.id) { index, forecast in
                    forecastRow(forecast, isFirst: index == 0)

                    if index < forecasts.count - 1 {
                        Divider()
                            .background(.white.opacity(0.2))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private func forecastRow(_ forecast: DayForecast, isFirst: Bool) -> some View {
        HStack {
            Text(isFirst ? "Hoy" : forecast.shortDayName)
                .font(.body)
                .foregroundStyle(.white)
                .frame(width: 60, alignment: .leading)

            Spacer()

            WeatherAnimationView(
                weatherCode: forecast.weatherCode,
                sfSymbol: forecast.weatherSymbol,
                size: 32
            )

            Spacer()

            HStack(spacing: 8) {
                Text("\(Int(forecast.minTemp))°")
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.body)

                Text("\(Int(forecast.maxTemp))°")
                    .foregroundStyle(.white)
                    .font(.body)
                    .fontWeight(.medium)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    // MARK: - Data Loading

    private func loadForecast() async {
        guard let city = cityStore.selectedCity else { return }
        isLoading = true
        errorMessage = nil
        do {
            forecasts = try await WeatherService.fetchForecast(for: city)
        } catch {
            errorMessage = error.localizedDescription
            forecasts = []
        }
        isLoading = false
    }
}
