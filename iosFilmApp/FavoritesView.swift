import SwiftUI

struct FavoritesView: View {
    @State private var favoriteMovies: [Movie] = []

    var body: some View {
        NavigationView {
            List(favoriteMovies, id: \.id) { movie in
                Text(movie.title)
            }
            .onAppear {
                loadFavoriteMovies()
            }
            .navigationBarTitle("Favoriten")
        }
    }

    // Funktion zum Laden der favorisierten Filme
    func loadFavoriteMovies() {
        var favorites: [Movie] = []
        
        // Überprüfen, ob Favoriten für alle gespeicherten IDs vorhanden sind
        for movieID in getAllMovieIDs() {
            if UserDefaults.standard.bool(forKey: "\(movieID)_favorited") {
                // Hier könnte ein Movie mit der ID geladen werden
                // Zum Beispiel eine API-Abfrage oder Verwendung eines Dummy-Modells
                favorites.append(Movie(id: movieID, title: "Sample Movie", releaseDate: "2024", overview: "Overview of movie", posterPath: "/path"))
            }
        }
        favoriteMovies = favorites
    }
    
    // Funktion zum Abrufen aller gespeicherten Movie-IDs
    func getAllMovieIDs() -> [Int] {
        // Zum Beispiel können hier alle gespeicherten Movie-IDs aus UserDefaults abgerufen werden
        return [1, 2, 3] // Beispielhafte IDs
    }
}
