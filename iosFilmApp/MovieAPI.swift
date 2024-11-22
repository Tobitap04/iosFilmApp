import Foundation

struct MovieAPI {
    static let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    static let baseURL = "https://api.themoviedb.org/3/"

    static func fetchMovies(forCategory category: String, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseURL)movie/\(category)?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching movies: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Error decoding movies: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        print("Poster URL: \(url?.absoluteString ?? "Kein Bild")")
        return url
    }
}
