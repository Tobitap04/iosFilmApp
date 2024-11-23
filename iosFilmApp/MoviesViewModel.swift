import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private var api = TMDBAPI()
    @Published var isFutureMovies: Bool = false

    init() {
        fetchMovies() // Initialer Abruf
    }

    func fetchMovies() {
        let endpoint = isFutureMovies ? "movie/upcoming" : "movie/now_playing"
        let urlString = "\(api.baseURL)/\(endpoint)?api_key=\(api.apiKey)&language=de"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Failed to fetch movies: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.movies = response.results // Setze die Filme in das ViewModel
                }
            } catch {
                print("Failed to decode movies: \(error)")
            }
        }.resume()
    }

    func toggleMovieCategory() {
        self.isFutureMovies.toggle() // Toggle den Status
        fetchMovies() // Lade die Filme erneut
    }
}
