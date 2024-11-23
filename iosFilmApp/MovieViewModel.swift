import Foundation

class MovieViewModel: ObservableObject {
    @Published var movies = [Movie]()
    
    private let tmdbService = TMDBService()
    
    // Fehlerbehebung: Beim Abrufen von Filmen müssen wir sicherstellen, dass die Methode korrekt aufgerufen wird.
    func fetchMovies(for category: String) {
        // Sicherstellen, dass die Kategorie korrekt ist (z.B. "now_playing" oder "upcoming")
        tmdbService.fetchMovies(for: category) { movies in
            self.movies = movies
        }
    }
}
