import Foundation

class FavoriteMoviesManager: ObservableObject {
    @Published var favoriteMovies: [Movie] = []
    
    private let storageKey = "favoriteMovies"
    
    init() {
        loadFavorites()
    }
    
    func addToFavorites(_ movie: Movie) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
            saveFavorites()
        }
    }
    
    func removeFromFavorites(_ movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
        saveFavorites()
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        favoriteMovies.contains(where: { $0.id == movie.id })
    }
    
    /// Wird benötigt, um Favoriten beim Start der App zu laden
    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            favoriteMovies = decoded
        }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteMovies) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
