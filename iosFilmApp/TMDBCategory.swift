//
//  TMDBCategory.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import Foundation


enum TMDBCategory {
    case nowPlaying
    case upcoming
}

class TMDBService {
    private static let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
    private static let baseURL = "https://api.themoviedb.org/3"
    
    static func fetchMovies(category: TMDBCategory, completion: @escaping ([Movie]) -> Void) {
        let endpoint: String
        switch category {
        case .nowPlaying:
            endpoint = "/movie/now_playing"
        case .upcoming:
            endpoint = "/movie/upcoming"
        }
        
        guard let url = URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)&language=de-DE") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(TMDBResponse.self, from: data)
                let movies = response.results.map { result in
                    Movie(
                        id: result.id,
                        title: result.title,
                        releaseDate: result.release_date,
                        overview: result.overview,
                        posterPath: "https://image.tmdb.org/t/p/w500\(result.poster_path)",
                        trailerURL: nil // Optionally load this separately
                    )
                }
                DispatchQueue.main.async {
                    completion(movies)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

struct TMDBResponse: Codable {
    let results: [TMDBMovieResult]
}

struct TMDBMovieResult: Codable {
    let id: Int
    let title: String
    let release_date: String
    let overview: String
    let poster_path: String
}



extension TMDBService {
    static func searchAll(query: String, completion: @escaping ([Movie]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([])
            return
        }

        let movieURL = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&language=de-DE"
        let personURL = "\(baseURL)/search/person?api_key=\(apiKey)&query=\(encodedQuery)&language=de-DE"

        // Gruppen-Task für parallele API-Aufrufe
        let group = DispatchGroup()
        var movies: [Movie] = []

        // Suche nach Filmen
        group.enter()
        URLSession.shared.dataTask(with: URL(string: movieURL)!) { data, _, _ in
            defer { group.leave() }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(TMDBResponse.self, from: data)
                let fetchedMovies = response.results.map { result in
                    Movie(
                        id: result.id,
                        title: result.title,
                        releaseDate: result.release_date,
                        overview: result.overview,
                        posterPath: "https://image.tmdb.org/t/p/w500\(result.poster_path)",
                        trailerURL: nil
                    )
                }
                movies.append(contentsOf: fetchedMovies)
            } catch {
                print("Error decoding movie results: \(error)")
            }
        }.resume()

        // Suche nach Personen (Schauspieler/Regisseure)
        group.enter()
        URLSession.shared.dataTask(with: URL(string: personURL)!) { data, _, _ in
            defer { group.leave() }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(TMDBPersonResponse.self, from: data)
                let personMovies = response.results.flatMap { person in
                    person.known_for.map { result in
                        Movie(
                            id: result.id,
                            title: result.title,
                            releaseDate: result.release_date,
                            overview: result.overview,
                            posterPath: "https://image.tmdb.org/t/p/w500\(result.poster_path)",
                            trailerURL: nil
                        )
                    }
                }
                movies.append(contentsOf: personMovies)
            } catch {
                print("Error decoding person results: \(error)")
            }
        }.resume()

        // Rückgabe nach Abschluss
        group.notify(queue: .main) {
            completion(movies)
        }
    }
}

struct TMDBPersonResponse: Codable {
    let results: [TMDBPersonResult]
}

struct TMDBPersonResult: Codable {
    let known_for: [TMDBMovieResult]
}



extension TMDBService {
    static func fetchTrailer(for movieID: Int, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: "\(baseURL)/movie/\(movieID)/videos?api_key=\(apiKey)&language=de-DE") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(TMDBTrailerResponse.self, from: data)
                // Suche nach dem YouTube-Trailer
                if let trailerKey = response.results.first(where: { $0.type == "Trailer" && $0.site == "YouTube" })?.key {
                    // Erzeuge die vollständige URL
                    let trailerURL = URL(string: "https://www.youtube.com/watch?v=\(trailerKey)")
                    completion(trailerURL)
                } else {
                    completion(nil) // Kein Trailer gefunden
                }
            } catch {
                print("Error decoding trailer data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

struct TMDBTrailerResponse: Codable {
    let results: [TMDBTrailer]
}

struct TMDBTrailer: Codable {
    let key: String
    let site: String
    let type: String
}
