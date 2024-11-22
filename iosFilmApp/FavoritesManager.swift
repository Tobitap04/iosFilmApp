import Foundation

class FavoritesManager: ObservableObject {
    @Published var favorites: [Movie] = []
    
    func addFavorite(movie: Movie) {
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
        }
    }
    
    func removeFavorite(movie: Movie) {
        favorites.removeAll { $0.id == movie.id }
    }
}
