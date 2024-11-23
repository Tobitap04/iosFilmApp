import SwiftUI
import Combine

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    var movieService = MovieService()
    
    func fetchMovies(for type: MovieListType) {
        movieService.fetchMovies(for: type) { [weak self] movies in
            DispatchQueue.main.async {
                self?.movies = movies ?? []
            }
        }
    }
}
