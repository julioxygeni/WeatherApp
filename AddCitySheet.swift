import SwiftUI

struct AddCitySheet: View {
    @EnvironmentObject private var cityStore: CityStore
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var results: [City] = []
    @State private var isSearching = false
    @State private var errorMessage: String?
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            Group {
                if isSearching {
                    ProgressView("Buscando...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if searchText.isEmpty {
                    ContentUnavailableView(
                        "Busca una ciudad",
                        systemImage: "magnifyingglass",
                        description: Text("Escribe el nombre de la ciudad que quieres agregar")
                    )
                } else if let error = errorMessage {
                    ContentUnavailableView(
                        "Error de búsqueda",
                        systemImage: "wifi.slash",
                        description: Text(error)
                    )
                } else if results.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List(results) { city in
                        Button {
                            cityStore.add(city)
                            cityStore.select(city)
                            dismiss()
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(city.name)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                HStack {
                                    Text(city.country)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Text(String(format: "%.2f°, %.2f°", city.latitude, city.longitude))
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Agregar ciudad")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        searchTask?.cancel()
                        dismiss()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Nombre de ciudad")
            .onChange(of: searchText) { _, newValue in
                searchTask?.cancel()
                guard !newValue.trimmingCharacters(in: .whitespaces).isEmpty else {
                    results = []
                    errorMessage = nil
                    return
                }
                searchTask = Task {
                    try? await Task.sleep(for: .milliseconds(400))
                    guard !Task.isCancelled else { return }
                    await performSearch(query: newValue)
                }
            }
        }
    }

    private func performSearch(query: String) async {
        isSearching = true
        errorMessage = nil
        do {
            results = try await WeatherService.searchCities(query: query)
        } catch {
            if !Task.isCancelled {
                errorMessage = error.localizedDescription
                results = []
            }
        }
        isSearching = false
    }
}
