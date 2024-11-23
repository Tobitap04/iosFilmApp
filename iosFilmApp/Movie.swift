import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let releaseDate: String?
    let overview: String?
    let posterPath: String?
    
    var trailerPath: String? // Trailer URL als veränderbare Eigenschaft hinzufügen

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case overview
        case posterPath = "poster_path"
    }

    var fullPosterPath: String? {
        guard let posterPath = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
}
