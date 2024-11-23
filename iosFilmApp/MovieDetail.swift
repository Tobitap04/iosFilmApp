import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String
    let overview: String
    let trailerURL: String?
}
