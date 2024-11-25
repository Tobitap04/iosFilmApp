import XCTest
import SwiftUI
@testable import iosFilmApp

// MARK: - Testdaten
let testMovies = [
    Movie(
        id: 912649,
        title: "Venom: The Last Dance",
        releaseDate: "2024-10-22",
        overview: "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision that will bring the curtains down on Venom and Eddie's last dance.",
        posterPath: "/ht8Uv9QPv9y7K0RvUyJIaXOZTfd.jpg",
        trailerURL: URL(string: "https://m.youtube.com/watch?v=M0suCEhUAx0")
    ),
    Movie(
        id: 1100782,
        title: "Zukünftiger Film",
        releaseDate: "2024-10-16",
        overview: "About to embark on a new world tour, global pop sensation Skye Riley begins experiencing increasingly terrifying and inexplicable events. Overwhelmed by the escalating horrors and the pressures of fame, Skye is forced to face her dark past to regain control of her life before it spirals out of control.",
        posterPath: "/ht8Uv9QPv9y7K0RvUyJIaXOZTfd.jpg",
        trailerURL: URL(string: "https://m.youtube.com/watch?v=WMtmisocnBE")
    )
]

// MARK: - Tests für FavoriteMoviesManager
final class FavoriteMoviesManagerTests: XCTestCase {
    var favoriteMoviesManager: FavoriteMoviesManager!

    override func setUp() {
        super.setUp()
        favoriteMoviesManager = FavoriteMoviesManager()
    }

    func testAddToFavorites() {
        favoriteMoviesManager.addToFavorites(testMovies[0])
        XCTAssertTrue(favoriteMoviesManager.isFavorite(testMovies[0]))
    }

    func testRemoveFromFavorites() {
        favoriteMoviesManager.addToFavorites(testMovies[1])
        favoriteMoviesManager.removeFromFavorites(testMovies[1])
        XCTAssertFalse(favoriteMoviesManager.isFavorite(testMovies[1]))
    }

    func testLoadAndSaveFavorites() {
        favoriteMoviesManager.addToFavorites(testMovies[0])
        let favoritesBeforeReload = favoriteMoviesManager.favoriteMovies
        favoriteMoviesManager = FavoriteMoviesManager() // Neue Instanz simuliert App-Neustart
        XCTAssertEqual(favoritesBeforeReload, favoriteMoviesManager.favoriteMovies)
    }
}

// MARK: - Tests für TMDBService
final class TMDBServiceTests: XCTestCase {
    func testFetchMovies() {
        let expectation = XCTestExpectation(description: "Fetch movies")
        
        TMDBService.fetchMovies(category: .nowPlaying) { movies in
            XCTAssertFalse(movies.isEmpty)
            XCTAssertEqual(movies[0].title, "Venom: The Last Dance") // Testet ersten Eintrag
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSearchAll() {
        let expectation = XCTestExpectation(description: "Search all movies and people")
        
        TMDBService.searchAll(query: "Venom: The Last Dance") { results in
            XCTAssertFalse(results.isEmpty)
            XCTAssertTrue(results.contains(where: { $0.title == "Venom: The Last Dance" }))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - Tests für MoviesView und SearchView
final class MoviesViewTests: XCTestCase {
    func testMoviesViewInitialLoad() {
        let view = MoviesView(movies: testMovies)
        XCTAssertNotNil(view.body)
    }
    
    func testPerformSearchLogic() {
        let expectation = XCTestExpectation(description: "Search logic test")
        
        TMDBService.searchAll(query: "Venom: The Last Dance") { results in
            XCTAssertTrue(results.contains { $0.title == "Venom: The Last Dance" }, "Die Suchergebnisse sollten den Film enthalten.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - Tests für MovieDetailView
final class MovieDetailViewTests: XCTestCase {
    func testFavoriteToggleLogic() {
        let manager = FavoriteMoviesManager()
        let movie = testMovies[0]
        manager.addToFavorites(movie)
        XCTAssertTrue(manager.isFavorite(movie))
        manager.removeFromFavorites(movie)
        XCTAssertFalse(manager.isFavorite(movie))
    }
}
