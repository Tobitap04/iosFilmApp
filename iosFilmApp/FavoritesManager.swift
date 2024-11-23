import Foundation

class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: [Movie] = []

    func addToFavorites(_ movie: Movie) {
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
        }
    }

    func removeFromFavorites(_ movie: Movie) {
        favorites.removeAll(where: { $0.id == movie.id })
    }

    func isFavorite(_ movie: Movie) -> Bool {
        return favorites.contains(where: { $0.id == movie.id }) // Korrekte Prüfung
    }
}
