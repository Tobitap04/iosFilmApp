import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MoviesView()
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
        .accentColor(.white)
        .background(Color.black.ignoresSafeArea())
    }
}
