import Foundation

enum WeatherService {
    static func searchCities(query: String) async throws -> [City] {
        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
        components.queryItems = [
            URLQueryItem(name: "name", value: query),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "language", value: "es"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GeocodingResponse.self, from: data)

        return (response.results ?? []).map { result in
            City(
                name: result.name,
                latitude: result.latitude,
                longitude: result.longitude,
                country: result.country ?? ""
            )
        }
    }

    static func fetchForecast(for city: City) async throws -> [DayForecast] {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(city.latitude)),
            URLQueryItem(name: "longitude", value: String(city.longitude)),
            URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min,weathercode"),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "7")
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ForecastResponse.self, from: data)

        let daily = response.daily
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return zip(daily.time, zip(daily.temperature2mMax, zip(daily.temperature2mMin, daily.weathercode)))
            .compactMap { time, temps in
                let (maxTemp, (minTemp, code)) = temps
                guard let date = formatter.date(from: time) else { return nil }
                return DayForecast(date: date, maxTemp: maxTemp, minTemp: minTemp, weatherCode: code)
            }
    }
}
