import Foundation

class MovieAPIManager {
    let apiKey = "453aa8a21df8d125bd9356fcd2a8e417" // Dein API-Key
    let baseURL = "https://api.themoviedb.org/3/"
    
    // Methode zum Abrufen von aktuellen Filmen
    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
        let urlString = "\(baseURL)movie/now_playing?api_key=\(apiKey)&language=en-US"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    // Hier wird die Antwort dekodiert
                    let response = try JSONDecoder().decode(MovieListResponse.self, from: data)
                    completion(response.results)
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
    
    // Methode zum Suchen von Filmen
    func searchMovies(query: String, completion: @escaping ([Movie]) -> Void) {
        let urlString = "\(baseURL)search/movie?api_key=\(apiKey)&query=\(query)&language=en-US"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    // Hier wird die Antwort dekodiert
                    let response = try JSONDecoder().decode(MovieListResponse.self, from: data)
                    completion(response.results)
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
}
