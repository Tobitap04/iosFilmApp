import Foundation

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private let api = TMDBApi()

    func loadMovies(for type: String) {
        api.fetchMovies(for: type) { [weak self] movies in
            DispatchQueue.main.async {
                self?.movies = movies
            }
        }
    }
}
