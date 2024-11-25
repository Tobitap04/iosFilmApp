import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject var moviesViewModel = MoviesViewModel()
    @StateObject var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                MovieListView(viewModel: moviesViewModel, favoritesViewModel: favoritesViewModel, isFutureMovies: false) // favoritesViewModel wird hier übergeben
                    .background(Color.black) // Hintergrund für den Inhalt
                    .foregroundColor(.white) // Textfarbe
            }
            .tabItem {
                Image(systemName: "film")
                Text("Filme")
                    .foregroundColor(Color.white) // Hellerer Text für Tab
            }
            .tag(0)

            NavigationView {
                SearchView(favoritesViewModel: favoritesViewModel) // favoritesViewModel wird hier übergeben
                    .background(Color.black) // Hintergrund für den Inhalt
                    .foregroundColor(.white) // Textfarbe
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.white) // Hellerer Text für Tab
                Text("Suche")
                    .foregroundColor(Color.white) // Hellerer Text für Tab
            }
            .tag(1)

            NavigationView {
                FavoritesView()
                    .background(Color.black) // Hintergrund für den Inhalt
                    .foregroundColor(.white) // Textfarbe
            }
            .tabItem {
                Image(systemName: "star")
                    .foregroundColor(Color.white) // Hellerer Text für Tab
                Text("Favoriten")
                    .foregroundColor(Color.white) // Hellerer Text für Tab
            }
            .tag(2)
        }
        .accentColor(.white) // Die Farbe für die Tab-Icons
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Hintergrund für den gesamten TabView
    }
}
