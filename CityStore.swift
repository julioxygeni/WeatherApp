import Foundation

@MainActor
final class CityStore: ObservableObject {
    @Published var cities: [City] = []
    @Published var selectedCity: City?

    private let citiesKey = "saved_cities"
    private let selectedCityKey = "selected_city_id"

    init() {
        load()
        if cities.isEmpty {
            let defaults = [
                City(name: "Madrid", latitude: 40.4168, longitude: -3.7038, country: "España"),
                City(name: "Barcelona", latitude: 41.3851, longitude: 2.1734, country: "España"),
                City(name: "Londres", latitude: 51.5074, longitude: -0.1278, country: "Reino Unido")
            ]
            cities = defaults
            selectedCity = defaults.first
            save()
        }
    }

    func add(_ city: City) {
        guard !cities.contains(where: { $0.name == city.name && $0.country == city.country }) else { return }
        cities.append(city)
        if selectedCity == nil {
            selectedCity = city
        }
        save()
    }

    func remove(at offsets: IndexSet) {
        let removedIds = offsets.map { cities[$0].id }
        cities.remove(atOffsets: offsets)
        if let selectedId = selectedCity?.id, removedIds.contains(selectedId) {
            selectedCity = cities.first
        }
        save()
    }

    func move(from source: IndexSet, to destination: Int) {
        cities.move(fromOffsets: source, toOffset: destination)
        save()
    }

    func select(_ city: City) {
        selectedCity = city
        UserDefaults.standard.set(city.id.uuidString, forKey: selectedCityKey)
    }

    // MARK: - Persistence

    private func load() {
        if let data = UserDefaults.standard.data(forKey: citiesKey),
           let decoded = try? JSONDecoder().decode([City].self, from: data) {
            cities = decoded
        }
        if let idString = UserDefaults.standard.string(forKey: selectedCityKey),
           let id = UUID(uuidString: idString) {
            selectedCity = cities.first(where: { $0.id == id })
        }
        if selectedCity == nil {
            selectedCity = cities.first
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(data, forKey: citiesKey)
        }
        if let id = selectedCity?.id {
            UserDefaults.standard.set(id.uuidString, forKey: selectedCityKey)
        }
    }
}
