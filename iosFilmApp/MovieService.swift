import Foundation

class MovieService {
    private let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    
    func fetchMovies(endpoint: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)&language=en-US"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}
