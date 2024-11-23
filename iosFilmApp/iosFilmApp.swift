import SwiftUI

@main
struct iosFilmApp: App {
    @StateObject private var favoritesManager = FavoritesManager() // Instanz von FavoritesManager

    var body: some Scene {
        WindowGroup {
            MainTabView(favoritesManager: favoritesManager) // favoritesManager an MainTabView übergeben
        }
    }
}
