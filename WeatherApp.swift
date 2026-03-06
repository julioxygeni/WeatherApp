import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var cityStore = CityStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cityStore)
        }
    }
}
