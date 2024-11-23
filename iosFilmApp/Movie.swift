import Foundation

struct Movie: Identifiable, Codable {
    var id: Int
    var title: String
    var releaseDate: String
    var overview: String
    var posterPath: String?  // Changed to optional String
    var voteAverage: Double
    var trailerKey: String?  // Trailer key from TMDB (if available)
    
    var isFavorite: Bool = false  // Mark for favorites
    var userReview: String? = nil  // User review (optional)
    
    enum CodingKeys: String, CodingKey {
        case id, title, releaseDate, overview, voteAverage
        case posterPath = "poster_path"
        case trailerKey = "trailer_key"
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
