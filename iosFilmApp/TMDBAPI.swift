import Foundation

class TMDBAPI {
    static let apiKey = "deine_tmdb_api_key"
    static let baseURL = "https://api.themoviedb.org/3/"
    
    static func fetchMovies(isCurrentMovies: Bool, completion: @escaping ([Movie]) -> Void) {
        let endpoint = isCurrentMovies ? "movie/now_playing" : "movie/upcoming"
        let url = URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                completion([])
            }
        }
        .resume()
    }
    
    static func searchMovies(query: String, completion: @escaping ([Movie]) -> Void) {
        let urlString = "\(baseURL)search/movie?api_key=\(apiKey)&query=\(query)"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                completion([])
            }
        }
        .resume()
    }
}

struct MovieResponse: Codable {
    var results: [Movie]
}