import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MovieListView(isCurrentMovies: true)
                .tabItem {
                    Image(systemName: "film")
                    Text("Filme")
                }

            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Suche")
                }

            FavoritesView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Favoriten")
                }
        }
        .accentColor(.white) // Setzt die Farbe der ausgewählten Tab
        .background(Color.black) // Hintergrundfarbe für die gesamte App
    }
}
