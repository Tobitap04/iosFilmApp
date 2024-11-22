import Foundation

struct Movie: Identifiable, Decodable {
    var id: Int
    var title: String
    var overview: String
    var posterPath: String? // optional, da nicht immer vorhanden
    
    // Coding Keys, um die JSON-Felder korrekt zu mappen
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
    }
}
