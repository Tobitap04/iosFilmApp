import Foundation

class TMDBAPI {
    let baseURL = "https://api.themoviedb.org/3"
    let apiKey = "453aa8a21df8d125bd9356fcd2a8e417" // Dein API-Schlüssel hier

    // Abruf der Filmvideos (Trailer) für einen Film
    func fetchMovieVideos(movieID: Int, completion: @escaping (String?) -> Void) {
        let urlString = "\(baseURL)/movie/\(movieID)/videos?api_key=\(apiKey)&language=de"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching movie videos: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                // Videos als Antwort decodieren
                let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
                if let trailer = videoResponse.results.first(where: { $0.type == "Trailer" }) {
                    completion(trailer.key) // Key für den Trailer zurückgeben
                } else {
                    completion(nil) // Kein Trailer gefunden
                }
            } catch {
                print("Failed to decode movie videos: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

// Model für die Videoantwort von der API
struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String // Der Schlüssel für den Trailer-Video-Link
    let type: String // Art des Videos (z.B. "Trailer")
}
