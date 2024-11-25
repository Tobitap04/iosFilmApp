import Foundation

class TMDBService {
    static let shared = TMDBService()
    
    private let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    private let baseURL = "https://api.themoviedb.org/3"
    
    func getNowPlayingMovies(completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=de-DE"
        fetchMovies(from: urlString, completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=de-DE"
        fetchMovies(from: urlString, completion: completion)
    }
    
    private func fetchMovies(from urlString: String, completion: @escaping ([Movie]?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Ungültige URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Fehler beim Abrufen der Filme: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Keine Daten erhalten")
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MovieListResponse.self, from: data)
                completion(decodedResponse.results)
            } catch {
                print("Fehler beim Dekodieren der Antwort: \(error)")
                // Ausgabe des fehlerhaften JSONs für das Debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Fehlerhafte JSON-Antwort: \(jsonString)")
                }
                completion(nil)
            }
        }
        
        task.resume()
    }
}

struct MovieListResponse: Decodable {
    let results: [Movie]
}
