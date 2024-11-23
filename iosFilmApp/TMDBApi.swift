import Foundation

class TMDBApi {
    private let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    private let baseURL = "https://api.themoviedb.org/3"

    func fetchMovies(for type: String, completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "\(baseURL)/movie/\(type)?api_key=\(apiKey)&language=de-DE") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Fehler beim Laden der Filme: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Fehler beim Dekodieren: \(error)")
            }
        }.resume()
    }

    func searchMovies(query: String, completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&language=de-DE&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Fehler beim Laden der Suchergebnisse: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Fehler beim Dekodieren: \(error)")
            }
        }.resume()
    }
}
