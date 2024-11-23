import Foundation

struct Movie: Identifiable, Codable {
    var id: Int
    var title: String
    var release_date: String
    var poster_path: String? // Posterbild kann optional sein
    var overview: String // Übersicht des Films (Zusammenfassung)
    var trailer: String? // Optionales Trailer-URL
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case release_date
        case poster_path
        case overview // Füge den overview-Schlüssel hinzu
        case trailer // Füge den Trailer-Schlüssel hinzu, falls benötigt
    }
}

struct MovieResponse: Codable {
    let results: [Movie] // Erwartet den "results"-Schlüssel aus der API-Antwort
}
