import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    private let favoritesKey = "favorites"
    
    private init() {}
    
    func addFavorite(movie: Movie) {
        var favorites = getFavorites()
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
            saveFavorites(favorites)
        }
    }
    
    func removeFavorite(movie: Movie) {
        var favorites = getFavorites()
        favorites.removeAll(where: { $0.id == movie.id })
        saveFavorites(favorites)
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return getFavorites().contains(where: { $0.id == movie.id })
    }
    
    func getFavorites() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
            return []
        }
        return movies
    }
    
    private func saveFavorites(_ movies: [Movie]) {
        if let data = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}
