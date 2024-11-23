import Foundation

struct Film: Identifiable, Codable {
    let id: Int
    let title: String
    let posterPath: String
    let releaseDate: String
}

struct FilmeResponse: Codable {
    let results: [Film]
}
