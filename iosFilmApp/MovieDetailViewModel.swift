import Foundation

class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie
    @Published var isFavorite: Bool
    @Published var reviewText: String
    
    init(movie: Movie, isFavorite: Bool = false, reviewText: String = "") {
        self.movie = movie
        self.isFavorite = isFavorite
        self.reviewText = reviewText
    }
    
    func toggleFavoriteStatus() {
        isFavorite.toggle()
        // Logik zum Speichern oder Entfernen des Films aus den Favoriten
    }
    
    func saveReview() {
        // Speichern der Benutzerbewertung (z.B. in UserDefaults, CoreData, etc.)
    }
}
