import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            FilmsViewController(tabIndex: 0)
                .tabItem {
                    Label("Filme", systemImage: "film")
                }
                .tag(0)

            SearchViewController(tabIndex: selectedTab)  // Übergebe den tabIndex als Int
                   .tabItem {
                       Label("Suche", systemImage: "magnifyingglass")
                   }
                   .tag(1)

            FavoritesViewController(tabIndex: 2)
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }
                .tag(2)
        }
        .accentColor(.white)  // Highlight the selected tab in white
        .background(Color.black)
    }
}
