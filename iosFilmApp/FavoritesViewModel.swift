import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Movie] = []
    
    func toggleFavorite(_ movie: Movie) {
        if let index = favorites.firstIndex(where: { $0.id == movie.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(movie)
        }
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains(where: { $0.id == movie.id })
    }
}
