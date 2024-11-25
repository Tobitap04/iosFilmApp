import Foundation

class MovieService {
    static let shared = MovieService()
    
    private let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    private let baseURL = "https://api.themoviedb.org/3/movie/"
    
    func fetchMovies(endpoint: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)\(endpoint)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                
                // Ausgabe der gesamten Antwort für Debugging
                print("API Response: \(String(data: data, encoding: .utf8) ?? "")")
                
                // Überprüfe, ob die `poster_path`-Daten tatsächlich vorhanden sind
                for movie in response.results {
                    print("Movie Title: \(movie.title), Poster Path: \(String(describing: movie.posterPath))")
                }
                
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}
