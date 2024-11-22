import Foundation

struct MovieListResponse: Decodable {
    var page: Int
    var results: [Movie]
    var totalPages: Int
    var totalResults: Int
    
    // Coding Keys, um die JSON-Felder korrekt zu mappen
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
