import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteMovies: [Movie] = []

    func addFavorite(movie: Movie) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
        }
    }

    func removeFavorite(movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
    }

    func isFavorite(movie: Movie) -> Bool {
        favoriteMovies.contains { $0.id == movie.id }
    }
}
