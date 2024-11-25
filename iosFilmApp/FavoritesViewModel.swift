import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favoriteMovies: [Movie] = []

    // Movie als Favorit hinzufügen und in UserDefaults speichern
    func addFavorite(movie: Movie) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
            saveFavoriteToUserDefaults(movie)
        }
    }

    // Movie als Favorit entfernen und aus UserDefaults entfernen
    func removeFavorite(movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
        removeFavoriteFromUserDefaults(movie)
    }

    // Überprüfen, ob ein Film favorisiert wurde
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id }
    }

    // Laden der Favoriten aus UserDefaults
    func loadFavoriteMovies() {
        var favorites: [Movie] = []

        // Favoriten aus UserDefaults laden
        let savedMoviesData = UserDefaults.standard.object(forKey: "favoriteMovies") as? Data
        if let savedMoviesData = savedMoviesData {
            let decoder = JSONDecoder()
            if let decodedMovies = try? decoder.decode([Movie].self, from: savedMoviesData) {
                favorites = decodedMovies
            } else {
                print("Fehler beim Dekodieren der Filme aus UserDefaults.")
            }
        }

        DispatchQueue.main.async {
            self.favoriteMovies = favorites
        }

        print("Favoriten geladen: \(self.favoriteMovies.count)")
    }

    // Speichern der Favoriten in UserDefaults
    private func saveFavoriteToUserDefaults(_ movie: Movie) {
        var currentFavorites = loadMoviesFromUserDefaults()
        currentFavorites.append(movie)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(currentFavorites) {
            UserDefaults.standard.set(encoded, forKey: "favoriteMovies")
        }
    }

    // Entfernen der Favoriten aus UserDefaults
    private func removeFavoriteFromUserDefaults(_ movie: Movie) {
        var currentFavorites = loadMoviesFromUserDefaults()
        currentFavorites.removeAll { $0.id == movie.id }

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(currentFavorites) {
            UserDefaults.standard.set(encoded, forKey: "favoriteMovies")
        }
    }

    // Laden der Filme aus UserDefaults
    private func loadMoviesFromUserDefaults() -> [Movie] {
        if let savedMoviesData = UserDefaults.standard.object(forKey: "favoriteMovies") as? Data {
            let decoder = JSONDecoder()
            if let decodedMovies = try? decoder.decode([Movie].self, from: savedMoviesData) {
                return decodedMovies
            }
        }
        return []
    }
}
