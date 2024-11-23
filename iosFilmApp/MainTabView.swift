import SwiftUI

struct MainTabView: View {
    // Instanziiere das ViewModel und den Manager
    @StateObject private var searchViewModel = SearchViewModel()
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some View {
        TabView {
            // Filme-Ansicht
            MoviesView()
                .tabItem {
                    Label("Filme", systemImage: "film")
                }

            // Suche-Ansicht mit Übergabe des ViewModels
            SearchView(searchViewModel: searchViewModel)
                .tabItem {
                    Label("Suche", systemImage: "magnifyingglass")
                }
            
            // Favoriten-Ansicht mit Übergabe des Managers
            FavoritesView(favoritesManager: favoritesManager)
                .tabItem {
                    Label("Favoriten", systemImage: "star.fill")
                }
        }
        .accentColor(.white)  // Akzentfarbe der Tabs
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .preferredColorScheme(.dark)  // Vorschau im Dunkelmodus
    }
}
