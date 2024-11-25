import SwiftUI

class FavoriteManager: ObservableObject {
    @Published var favoriteMovies: Set<Int> = Set()

    init() {
        // Initialisiere den Favoritenstatus aus UserDefaults
        if let savedFavorites = UserDefaults.standard.array(forKey: "favoriteMovies") as? [Int] {
            self.favoriteMovies = Set(savedFavorites)
        }
    }

    func toggleFavorite(for movieID: Int) {
        if favoriteMovies.contains(movieID) {
            favoriteMovies.remove(movieID)
        } else {
            favoriteMovies.insert(movieID)
        }
        // Speichern des aktuellen Favoritenstatus
        UserDefaults.standard.set(Array(favoriteMovies), forKey: "favoriteMovies")
    }

    func isFavorite(movieID: Int) -> Bool {
        return favoriteMovies.contains(movieID)
    }
}
