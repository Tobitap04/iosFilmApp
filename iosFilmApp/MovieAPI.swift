import Foundation

// MovieResponse Model - Dies spiegelt die Antwort der API mit einer Liste von Movies wider
struct MovieResponse: Decodable {
    var results: [Movie]
}

class MovieAPI {
    static let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    
    static func fetchMovies(type: String, completion: @escaping ([Movie]) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(type)?api_key=\(apiKey)&language=de-DE"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results)
                }
            } catch {
                completion([])
            }
        }
        task.resume()
    }
    
    // Methode zum Abrufen des Trailers
    static func fetchMovieTrailer(movieId: Int, completion: @escaping (String?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(apiKey)&language=de-DE"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(VideoResponse.self, from: data)
                // Wir gehen davon aus, dass das erste Video das Trailer-Video ist
                if let trailer = response.results.first(where: { $0.type == "Trailer" }) {
                    completion(trailer.key)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}

// Video und VideoResponse Model - Dies spiegelt die Video-Antwort der API wider
struct VideoResponse: Decodable {
    var results: [Video]
}

struct Video: Decodable {
    var key: String
    var type: String
}
