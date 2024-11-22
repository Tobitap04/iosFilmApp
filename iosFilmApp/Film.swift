import Foundation

struct Film: Identifiable, Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let posterPath: String?  // Optional String für posterPath
    let video: Bool
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, title, releaseDate = "release_date", overview, posterPath = "poster_path", video
    }

    // Full image URL
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
