import Foundation

class TMDBAPI {
    static let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    static let baseURL = "https://api.themoviedb.org/3/"
    
    static func fetchMovies(isCurrentMovies: Bool, completion: @escaping ([Movie]) -> Void) {
        let endpoint = isCurrentMovies ? "movie/now_playing" : "movie/upcoming"
        let url = URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                print("No data received")  // Wenn keine Daten empfangen wurden
                completion([])
                return
            }
            
            // Geben Sie die rohen Daten aus, um zu sehen, was von der API zurückgegeben wird
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw API response: \(jsonString)")  // Ausgabe der rohen API-Antwort
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                print("Decoded Movies: \(response.results)")  // Ausgabe der decodierten Filme
                completion(response.results)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")  // Fehler beim Decodieren der Daten
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

// Diese Struktur repräsentiert einen Film, der von der TMDB-API kommt
struct Movie: Identifiable, Codable {
    var id: Int
    var title: String
    var releaseDate: String
    var overview: String
    var posterPath: String?  // Optionale Eigenschaft für das Poster
    var trailerKey: String?  // Optionale Eigenschaft für den Trailer-Link

    // Computed Property für das vollständige Poster-Bild-URL
    var posterURL: URL? {
        // Sicherstellen, dass posterPath optional ist und den korrekten Wert hat
        guard let path = posterPath, !path.isEmpty else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    // Computed Property für das Datum in einem formatierbaren Format
    var releaseFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: releaseDate) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        }
        return releaseDate
    }
}

// Antwort von der TMDB API für Filme
struct MovieResponse: Codable {
    var results: [Movie]
}
