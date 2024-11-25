import SwiftUI

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let favoritesKey = "favorites"
    
    func saveFavoriteMovie(_ movie: Movie) {
        var favorites = loadFavorites()
        if !favorites.contains(movie.id) {
            favorites.append(movie.id)
            UserDefaults.standard.set(favorites, forKey: favoritesKey)
        }
    }
    
    func loadFavorites() -> [Int] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        return loadFavorites().contains(movie.id)
    }
}
