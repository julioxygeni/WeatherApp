import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var cityStore: CityStore
    @State private var showingAddCity = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(cityStore.cities) { city in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(city.name)
                                .font(.body)
                            Text(city.country)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if city.id == cityStore.selectedCity?.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        cityStore.select(city)
                    }
                }
                .onDelete(perform: cityStore.remove)
                .onMove(perform: cityStore.move)
            }
            .navigationTitle("Ciudades")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showingAddCity = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCity) {
                AddCitySheet()
            }
        }
    }
}
