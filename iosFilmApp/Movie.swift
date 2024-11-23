import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?
    let overview: String

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
    }
}
