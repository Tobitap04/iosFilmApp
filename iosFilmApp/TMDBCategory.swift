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
    static func searchMovies(query: String, completion: @escaping ([Movie]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&language=de-DE") else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            do {
                let response = try JSONDecoder().decode(TMDBResponse.self, from: data)
                let movies = response.results.map { result in
                    Movie(
                        id: result.id,
                        title: result.title,
                        releaseDate: result.release_date,
                        overview: result.overview,
                        posterPath: "https://image.tmdb.org/t/p/w500\(result.poster_path)",
                        trailerURL: nil
                    )
                }
                DispatchQueue.main.async {
                    completion(movies)
                }
            } catch {
                print("Error decoding search results: \(error)")
                completion([])
            }
        }.resume()
    }
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
                let trailerPath = response.results.first(where: { $0.type == "Trailer" && $0.site == "YouTube" })?.key
                if let path = trailerPath {
                    completion(URL(string: "https://www.youtube.com/watch?v=\(path)"))
                } else {
                    completion(nil)
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
