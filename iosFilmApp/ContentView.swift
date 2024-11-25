import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MoviesView()
                .tabItem {
                    Label("Filme", systemImage: "film")
                }
            
            SearchView()
                .tabItem {
                    Label("Suche", systemImage: "magnifyingglass")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoriten", systemImage: "star.fill") // Geändertes Icon
                }
        }
        .accentColor(.white) // Farbe für aktives Tab geändert
        .background(Color.black)
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        }
    }
}
