import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var movies: [Movie] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.searchMovies()
            }
            .store(in: &cancellables)
    }

    func searchMovies() {
        guard !query.isEmpty else {
            movies = []
            return
        }
        
        // API-Call zu TMDB oder einer anderen Quelle, um Filme zu suchen
        // Beispiel:
        MovieAPI.searchMovies(query: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
            case .failure:
                self?.movies = []
            }
        }
    }
}
