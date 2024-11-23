import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteMovies: [Movie] = []
    
    private let favoritesKey = "favorites"
    
    init() {
        loadFavorites()
    }
    
    func addFavorite(movie: Movie) {
        favoriteMovies.append(movie)
        saveFavorites()
    }
    
    func removeFavorite(movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
        saveFavorites()
    }
    
    private func saveFavorites() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favoriteMovies) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let savedData = UserDefaults.standard.data(forKey: favoritesKey),
           let decodedFavorites = try? JSONDecoder().decode([Movie].self, from: savedData) {
            favoriteMovies = decodedFavorites
        }
    }
}
