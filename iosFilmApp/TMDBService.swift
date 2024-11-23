import Foundation

class TMDBService {
    private let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"  // Ersetze mit deinem TMDb API-Schlüssel
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchMovies(for category: String, completion: @escaping ([Movie]) -> Void) {
        let urlString = "\(baseURL)/movie/\(category)?api_key=\(apiKey)&language=de-DE&page=1"
        guard let url = URL(string: urlString) else {
            print("Ungültige URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Fehler beim Abrufen der Daten: \(error?.localizedDescription ?? "Unbekannter Fehler")")
                return
            }
            
            // Diagnose: Protokolliere die rohen Daten, um zu sehen, was von der API zurückgegeben wird
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Rohe API-Antwort: \(jsonString)")  // Protokolliere die Antwort
            }
            
            do {
                let result = try JSONDecoder().decode(MovieListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.results)
                }
            } catch {
                print("Fehler beim Decodieren der Antwort: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchMovieDetail(movieID: Int, completion: @escaping (MovieDetail) -> Void) {
        let urlString = "\(baseURL)/movie/\(movieID)?api_key=\(apiKey)&language=de-DE"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            // Diagnose: Protokolliere die rohen Daten der Film-Detailantwort
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Rohe Film-Detail-Antwort: \(jsonString)")  // Protokolliere die Antwort
            }
            
            do {
                let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                DispatchQueue.main.async {
                    completion(movieDetail)
                }
            } catch {
                print("Fehler beim Decodieren der Film-Details: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct MovieListResponse: Codable {
    let results: [Movie]
}
