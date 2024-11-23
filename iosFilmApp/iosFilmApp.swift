import SwiftUI

@main
struct iosFilmApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MoviesView(type: .currentMovies)  // Übergebe den aktuellen Filmmodus hier
                    .tabItem {
                        Label("Filme", systemImage: "film")
                    }
                
                SearchView()
                    .tabItem {
                        Label("Suche", systemImage: "magnifyingglass")
                    }
                
                FavoritesView()
                    .tabItem {
                        Label("Favoriten", systemImage: "star.fill")
                    }
            }
            .accentColor(.white)
        }
    }
}
