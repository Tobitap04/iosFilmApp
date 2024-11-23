import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published var currentMovies: [Movie] = [] // Aktuelle Filme
    @Published var upcomingMovies: [Movie] = [] // Zukünftige Filme
    private var cancellables = Set<AnyCancellable>() // Set von Cancellables für Combine

    // Funktion zum Abrufen der aktuellen Filme
    func loadCurrentMovies() {
        APIManager.shared.fetchMovies(type: .current) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.currentMovies = movies
                }
            case .failure(let error):
                print("Fehler beim Laden der aktuellen Filme: \(error.localizedDescription)")
            }
        }
    }

    // Funktion zum Abrufen der zukünftigen Filme
    func loadUpcomingMovies() {
        APIManager.shared.fetchMovies(type: .upcoming) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.upcomingMovies = movies
                }
            case .failure(let error):
                print("Fehler beim Laden der zukünftigen Filme: \(error.localizedDescription)")
            }
        }
    }
}
