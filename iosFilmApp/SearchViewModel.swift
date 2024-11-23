import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchResults: [Movie] = []
    @Published var query: String = "" // Hier wird die query-Eigenschaft hinzugefügt
    private let api = TMDBAPI()

    func searchMovies() {
        guard !query.isEmpty else { return }
        let urlString = "\(api.baseURL)/search/movie?api_key=\(api.apiKey)&query=\(query)&language=de"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Search error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = response.results
                    // Lade zusätzlich die Trailer für die gefundenen Filme
                    self.fetchTrailersForMovies()
                }
            } catch {
                print("Failed to decode search results: \(error)")
            }
        }.resume()
    }

    func fetchTrailersForMovies() {
        for (index, movie) in searchResults.enumerated() {
            api.fetchMovieVideos(movieID: movie.id) { trailerKey in
                DispatchQueue.main.async {
                    // Setze die Trailer-URL für jedes Filmobjekt
                    self.searchResults[index].trailerPath = trailerKey != nil ? "https://www.youtube.com/watch?v=\(trailerKey!)" : nil
                }
            }
        }
    }
}



struct MovieResponse: Codable {
    let page: Int
    let results: [Movie] // Eine Liste der Filme
    let totalResults: Int? // Optional, falls der Schlüssel im JSON fehlt
    let totalPages: Int?  // Optional, falls der Schlüssel im JSON fehlt
}
