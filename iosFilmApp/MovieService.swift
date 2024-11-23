// MovieService.swift

import Foundation

class MovieService {
    static let apiKey = "453aa8a21df8d125bd9356fcd2a8e417" // Ersetze mit deinem TMDB API-Schlüssel
    static let baseURL = "https://api.themoviedb.org/3/"
    
    // Cache für Favoriten
    static var favoriteMovies = [Movie]()
    
    // Methode, um aktuelle Filme abzurufen
    static func getCurrentMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=de-DE&page=1")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fehler beim Abrufen der aktuellen Filme: \(error)")  // Debugging-Ausgabe
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("Keine Daten empfangen.")  // Debugging-Ausgabe
                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: nil)))
                return
            }
            
            // Protokolliere die gesamte API-Antwort als JSON-String zur Überprüfung
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API Antwort: \(jsonString)")  // Debugging-Ausgabe
            }
            
            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                print("Aktuelle Filme geladen: \(movieResponse.results.count) Filme")  // Debugging-Ausgabe
                completion(.success(movieResponse.results))
            } catch {
                print("Fehler beim Decodieren der Filmantwort: \(error)")  // Debugging-Ausgabe
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    // Methode, um zukünftige Filme abzurufen
    static func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=de-DE&page=1")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // Abrufen von Filmen (Aktuell oder Zukünftig)
    static func fetchMovies(type: MoviesView.MovieType, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let endpoint = type == .currentMovies ? "movie/now_playing" : "movie/upcoming"
        let url = URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Invalid Data", code: 0)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Suche nach Filmen
    static func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = URL(string: "\(baseURL)search/movie?api_key=\(apiKey)&query=\(query)")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Invalid Data", code: 0)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Speichern eines Filmes in den Favoriten
    static func addFavoriteMovie(movie: Movie) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
        }
    }
    
    // Entfernen eines Filmes aus den Favoriten
    static func removeFavoriteMovie(movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
    }
    
    // Abrufen der gespeicherten Favoriten
    static func getFavoriteMovies() -> [Movie] {
        return favoriteMovies
    }
    
    // Bewerten eines Filmes
    static func rateMovie(movie: Movie, review: String) {
        if let index = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
            favoriteMovies[index].userReview = review
        }
    }
    
    // Trailer des Films abrufen
    static func getTrailerKey(forMovie movieId: Int, completion: @escaping (Result<String?, Error>) -> Void) {
        let url = URL(string: "\(baseURL)movie/\(movieId)/videos?api_key=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Invalid Data", code: 0)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TrailerResponse.self, from: data)
                completion(.success(response.results.first?.key))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Helper-Model für Antwort von TMDB
struct MovieResponse: Decodable {
    let results: [Movie]
}

struct TrailerResponse: Decodable {
    let results: [Trailer]
}

struct Trailer: Decodable {
    let key: String
}
