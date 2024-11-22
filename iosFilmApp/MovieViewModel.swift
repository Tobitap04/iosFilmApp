import Foundation

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    
    func fetchMovies() {
        MovieAPI.fetchMovies(forCategory: "now_playing") { [weak self] movies in
            DispatchQueue.main.async {
                self?.movies = movies ?? []
            }
        }
    }
}
