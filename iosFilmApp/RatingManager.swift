import Foundation

class RatingManager: ObservableObject {
    func saveRating(_ rating: String, for movieID: Int) {
        UserDefaults.standard.set(rating, forKey: "\(movieID)-rating")
    }

    func getRating(for movieID: Int) -> String? {
        return UserDefaults.standard.string(forKey: "\(movieID)-rating")
    }
}
