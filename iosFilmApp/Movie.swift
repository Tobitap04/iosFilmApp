import Foundation

struct Movie: Identifiable, Decodable, Encodable { // Hinzugefügt: Encodable
    var id: Int
    var title: String
    var overview: String
    var releaseDate: String?
    var posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate
        case posterPath = "poster_path"
    }
}
