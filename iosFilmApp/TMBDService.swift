import Foundation

class TMDBService {
    private let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    private let baseURL = "https://api.themoviedb.org/3/"

    func fetchMovies(type: String, completion: @escaping ([Film]?) -> Void) {
        let urlString = "\(baseURL)movie/\(type)?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let movieResponse = try? JSONDecoder().decode(MovieResponse.self, from: data) {
                completion(movieResponse.results)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    func searchMovies(query: String, completion: @escaping ([Film]?) -> Void) {
        let urlString = "\(baseURL)search/movie?api_key=\(apiKey)&query=\(query)&language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let movieResponse = try? JSONDecoder().decode(MovieResponse.self, from: data) {
                completion(movieResponse.results)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

struct MovieResponse: Codable {
    let results: [Film]
}
