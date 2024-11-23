import Foundation

class ReviewManager {
    static let shared = ReviewManager()
    
    private let reviewsKey = "movieReviews"

    private init() {}
    
    // Speichert die Bewertung für einen Film
    func saveReview(for movie: Movie, review: String) {
        var allReviews = loadAllReviews()
        allReviews[movie.id] = review
        saveAllReviews(allReviews)
    }
    
    // Lädt die Bewertung für einen bestimmten Film
    func getReview(for movie: Movie) -> String? {
        let allReviews = loadAllReviews()
        return allReviews[movie.id]
    }
    
    // Entfernt die Bewertung für einen Film
    func removeReview(for movie: Movie) {
        var allReviews = loadAllReviews()
        allReviews.removeValue(forKey: movie.id)
        saveAllReviews(allReviews)
    }
    
    // Lädt alle gespeicherten Bewertungen
    private func loadAllReviews() -> [Int: String] {
        guard let data = UserDefaults.standard.data(forKey: reviewsKey),
              let reviews = try? JSONDecoder().decode([Int: String].self, from: data) else {
            return [:]
        }
        return reviews
    }
    
    // Speichert alle Bewertungen in UserDefaults
    private func saveAllReviews(_ reviews: [Int: String]) {
        guard let data = try? JSONEncoder().encode(reviews) else { return }
        UserDefaults.standard.set(data, forKey: reviewsKey)
    }
}
