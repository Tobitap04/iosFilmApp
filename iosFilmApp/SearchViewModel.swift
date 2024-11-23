import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchResults: [Movie] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Funktion zum Suchen von Filmen
    func searchMovies(query: String, type: APIManager.MovieType) {
        // Stelle sicher, dass der API-Aufruf nur durchgeführt wird, wenn es eine gültige Suchanfrage gibt
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }

        APIManager.shared.fetchMovies(type: type) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    // Filtere Filme basierend auf der Suchanfrage
                    self?.searchResults = movies.filter {
                        $0.title.lowercased().contains(query.lowercased()) ||
                        $0.release_date.lowercased().contains(query.lowercased()) ||
                        $0.overview.lowercased().contains(query.lowercased())
                    }
                }
            case .failure(let error):
                print("Fehler beim Suchen der Filme: \(error.localizedDescription)")
            }
        }
    }
}
