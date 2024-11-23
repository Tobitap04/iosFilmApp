import Foundation

class RatingManager {
    static let favoritesKey = "favorites"
    
    static func updateFavorites(movie: Movie, isFavorite: Bool) {
        var favorites = getFavorites()
        
        if isFavorite {
            favorites.append(movie)
        } else {
            favorites.removeAll { $0.id == movie.id }
        }
        
        saveFavorites(favorites)
    }
    
    static func getFavorites() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let decoded = try? JSONDecoder().decode([Movie].self, from: data) else {
            return []
        }
        return decoded
    }
    
    static func saveFavorites(_ movies: [Movie]) {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
}
