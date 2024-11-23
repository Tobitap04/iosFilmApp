import Foundation

// Diese Struktur stellt einen Film dar, der als Favorit gespeichert wurde
struct FavoriteMovie: Codable, Identifiable {
    var id: Int
    var title: String
    var posterPath: String
    var releaseDate: String

    // Methode zum Hinzufügen eines Films zu den Favoriten
    static func addToFavorites(movie: Movie) {
        var favorites = loadFavorites()
        let favoriteMovie = FavoriteMovie(id: movie.id, title: movie.title, posterPath: movie.posterPath, releaseDate: movie.releaseDate)
        favorites.append(favoriteMovie)
        saveFavorites(favorites)
    }
    
    // Methode zum Entfernen eines Films aus den Favoriten
    static func removeFromFavorites(movie: Movie) {
        var favorites = loadFavorites()
        favorites.removeAll { $0.id == movie.id }
        saveFavorites(favorites)
    }
    
    // Laden der Favoriten aus UserDefaults
    static func loadFavorites() -> [FavoriteMovie] {
        if let data = UserDefaults.standard.data(forKey: "favoriteMovies") {
            let decoder = JSONDecoder()
            if let favorites = try? decoder.decode([FavoriteMovie].self, from: data) {
                return favorites
            }
        }
        return []
    }
    
    // Speichern der Favoriten in UserDefaults
    private static func saveFavorites(_ favorites: [FavoriteMovie]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favoriteMovies")
        }
    }
    
    // Überprüfen, ob ein Film bereits in den Favoriten vorhanden ist
    static func isFavorite(movie: Movie) -> Bool {
        let favorites = loadFavorites()
        return favorites.contains { $0.id == movie.id }
    }
}