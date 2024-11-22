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

}

struct MovieResponse: Decodable {
    let results: [Movie]
}


import Foundation

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    
    // JSON-Schlüssel korrekt zuordnen
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date" // Mappt `release_date` aus JSON auf `releaseDate`
        case posterPath = "poster_path"  // Mappt `poster_path` auf `posterPath`
    }
    
    var imageUrl: String {
        if let posterPath = posterPath {
            return "https://image.tmdb.org/t/p/w500\(posterPath)"
        }
        return ""
    }
}


