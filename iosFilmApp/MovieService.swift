import Foundation

class MovieService {
    func fetchMovies(for type: MovieListType, completion: @escaping ([Movie]?) -> Void) {
        let urlString: String
        
        switch type {
        case .current:
            urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=453aa8a21df8d125bd9356fcd2a8e417"
        case .upcoming:
            urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=453aa8a21df8d125bd9356fcd2a8e417"
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Fehler beim Abrufen der Filme: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Fehler beim Dekodieren der Filme: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }

    func searchMovies(query: String, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=453aa8a21df8d125bd9356fcd2a8e417&query=\(query)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Fehler beim Suchen der Filme: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Fehler beim Dekodieren der Suchergebnisse: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func fetchMovieTrailer(for movieId: Int, completion: @escaping (String?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=453aa8a21df8d125bd9356fcd2a8e417"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Fehler beim Abrufen des Trailers: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieTrailerResponse.self, from: data)
                if let trailer = response.results.first {
                    completion("https://www.youtube.com/watch?v=\(trailer.key)")
                } else {
                    completion(nil)
                }
            } catch {
                print("Fehler beim Dekodieren des Trailers: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }

    struct MovieTrailerResponse: Decodable {
        let results: [Trailer]
    }

    struct Trailer: Decodable {
        let key: String
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let poster_path: String
    let release_date: String
    let overview: String
    let trailerURL: String?  // Optionaler Trailer-URL

    var imageUrl: URL {
        URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)")!
    }
}

struct TrailerResponse: Decodable {
    let results: [Trailer]
}

struct Trailer: Decodable {
    let key: String
}
