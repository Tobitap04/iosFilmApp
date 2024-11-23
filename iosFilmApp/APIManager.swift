import Foundation

class APIManager {
    static let shared = APIManager() // Singleton für die API-Instanz
    
    private let apiKey = "453aa8a21df8d125bd9356fcd2a8e417" // Ersetze dies durch deinen echten API-Schlüssel
    private let baseURL = "https://api.themoviedb.org/3"

    // Enum für die verschiedenen Typen von Filmen
    enum MovieType {
        case current
        case upcoming
    }

    // Funktion zum Abrufen von Filmen (entweder aktuelle oder zukünftige Filme)
    func fetchMovies(type: MovieType, completion: @escaping (Result<[Movie], Error>) -> Void) {
        var urlString: String
        switch type {
        case .current:
            urlString = "\(baseURL)/movie/now_playing?api_key=\(apiKey)"
        case .upcoming:
            urlString = "\(baseURL)/movie/upcoming?api_key=\(apiKey)"
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(MovieListResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}



struct MovieListResponse: Codable {
    let results: [Movie]
}
