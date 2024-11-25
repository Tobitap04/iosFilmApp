import Foundation

struct Movie: Identifiable, Decodable {
    var id: Int
    var title: String
    var overview: String
    var releaseDate: String
    var posterPath: String?
    
    // Optional: Falls die JSON-Schlüssel von den Variablennamen abweichen
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}

func parseMovieData(json: [String: Any]) -> [Movie] {
    guard let results = json["results"] as? [[String: Any]] else { return [] }

    var movies: [Movie] = []
    for result in results {
        if let title = result["title"] as? String,
           let releaseDate = result["release_date"] as? String,
           let overview = result["overview"] as? String,
           let posterPath = result["poster_path"] as? String {
            let movie = Movie(id: 0, title: title, overview: overview, releaseDate: releaseDate, posterPath: posterPath)
            movies.append(movie)
        }
    }
    return movies
}
