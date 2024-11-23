import SwiftUI

struct MainTabView: View {
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
                    Image(systemName: "heart")
                    Text("Favoriten")
                }
        }
        .accentColor(.white)
        .background(Color.black)
    }
}
