import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            FilmListView(title: "Aktuelle Filme", movieType: .nowPlaying)
                .tabItem {
                    Label("Filme", systemImage: "film")
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Label("Suche", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Label("Favoriten", systemImage: "star.fill")
                }
                .tag(2)
        }
        .accentColor(.white)
        .background(Color.black)
    }
}
