import Foundation

class TMDBService {
    private let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    private let baseUrl = "https://api.themoviedb.org/3"
    
    func fetchMovies(endpoint: String, completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "\(baseUrl)/movie/\(endpoint)?api_key=\(apiKey)&language=de-DE") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Fehler beim Abrufen von Filmen: \(String(describing: error))")
                return
            }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Fehler beim Dekodieren: \(error)")
            }
        }.resume()
    }


    func fetchTrailer(for movieId: Int, completion: @escaping (String?) -> Void) {
        let urlString = "\(baseUrl)/movie/\(movieId)/videos?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Fehler beim Abrufen des Trailers: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TrailerResponse.self, from: data)
                let trailer = response.results.first
                completion(trailer?.key) // trailer?.key ist die Trailer-ID, die in eine URL übersetzt werden muss
            } catch {
                print("Fehler beim Dekodieren der Trailer-Daten: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    struct TrailerResponse: Codable {
        let results: [Trailer]
    }

    struct Trailer: Codable {
        let key: String
    }

    
    func searchMovies(query: String, completion: @escaping ([Movie]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)/search/movie?api_key=\(apiKey)&language=de-DE&query=\(encodedQuery)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Fehler bei der Suche: \(String(describing: error))")
                return
            }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Fehler beim Dekodieren der Suche: \(error)")
            }
        }.resume()
    }
    
    func fetchSearchResults(query: String, completion: @escaping ([Movie]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Fehler beim Kodieren des Suchbegriffs")
            completion([])
            return
        }
        
        let urlString = "\(baseUrl)/search/movie?api_key=\(apiKey)&language=de-DE&query=\(encodedQuery)"
        guard let url = URL(string: urlString) else {
            print("Ungültige URL: \(urlString)")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Fehler beim Abrufen von Suchergebnissen: \(String(describing: error))")
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Fehler beim Dekodieren von Suchergebnissen: \(error)")
                completion([])
            }
        }.resume()
    }

}

struct MovieResponse: Decodable {
    let results: [Movie]
}


import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    var trailerUrl: String? // Optionaler Wert für den Trailer
    
    // JSON-Schlüssel korrekt zuordnen
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date" // Mappt `release_date` aus JSON auf `releaseDate`
        case posterPath = "poster_path"  // Mappt `poster_path` auf `posterPath`
        case trailerUrl
    }
    
    var imageUrl: String {
        if let posterPath = posterPath {
            return "https://image.tmdb.org/t/p/w500\(posterPath)"
        }
        return ""
    }
    
    func getTrailerUrl() -> String? {
           return self.trailerUrl ?? "https://www.example.com/trailer.mp4" // Beispiel-URL
       }
}


