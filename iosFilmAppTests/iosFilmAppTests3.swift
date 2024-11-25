import XCTest
@testable import iosFilmApp

class iosFilmAppTests3: XCTestCase {

    // Beispiel-Filme
    let movies = [
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
    
    var favoriteMoviesManager: FavoriteMoviesManager!
    
    override func setUp() {
        super.setUp()
        favoriteMoviesManager = FavoriteMoviesManager()
    }
    
    func testAddToFavorites() {
        favoriteMoviesManager.addToFavorites(movies[0])
        XCTAssertTrue(favoriteMoviesManager.favoriteMovies.contains(where: { $0.id == movies[0].id }))
    }
    
    func testRemoveFromFavorites() {
        favoriteMoviesManager.addToFavorites(movies[0])
        favoriteMoviesManager.removeFromFavorites(movies[0])
        XCTAssertFalse(favoriteMoviesManager.favoriteMovies.contains(where: { $0.id == movies[0].id }))
    }

    func testIsFavorite() {
        favoriteMoviesManager.addToFavorites(movies[1])
        XCTAssertTrue(favoriteMoviesManager.isFavorite(movies[1]))
    }
    
    func testPersistence() {
        favoriteMoviesManager.addToFavorites(movies[0])
        favoriteMoviesManager.saveFavorites()
        favoriteMoviesManager.favoriteMovies = []
        favoriteMoviesManager.loadFavorites()
        XCTAssertTrue(favoriteMoviesManager.favoriteMovies.contains(where: { $0.id == movies[0].id }))
    }
    
    // MARK: - Tests für TMDBService
    
    func testFetchTrailer() {
        let expectation = XCTestExpectation(description: "Fetch Trailer")
        TMDBService.fetchTrailer(for: movies[0].id) { url in
            XCTAssertNotNil(url)
            XCTAssertTrue(url?.absoluteString.contains("youtube.com") ?? false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testPerformSearch() {
        let expectation = XCTestExpectation(description: "Search Movies")
        TMDBService.searchAll(query: "Venom: The Last Dance") { results in
            XCTAssertFalse(results.isEmpty)
            XCTAssertTrue(results.contains(where: { $0.title.contains("Venom: The Last Dance") }))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testInvalidJSONResponse() {
        let invalidData = Data("{invalid}".utf8)
        XCTAssertThrowsError(try JSONDecoder().decode(TMDBResponse.self, from: invalidData))
    }

    // MARK: - Tests für ReviewView
    
    func testSaveReview() {
        let review = "This is a test review"
        let movieID = movies[0].id
        UserDefaults.standard.set(review, forKey: "\(movieID)-review")
        let savedReview = UserDefaults.standard.string(forKey: "\(movieID)-review")
        XCTAssertEqual(review, savedReview)
    }

    // MARK: - UI Tests für ContentView
    
    
    // MARK: - Fehlerfall: Leere Favoriten
    
    func testEmptyFavoritesLogic() {
        // Sicherstellen, dass UserDefaults leer ist
        UserDefaults.standard.removeObject(forKey: "favoriteMovies")
        
        // Initialisiere den Manager
        let favoriteMoviesManager = FavoriteMoviesManager()
        
        // Test
        XCTAssertTrue(favoriteMoviesManager.favoriteMovies.isEmpty, "Die Favoritenliste sollte leer sein.")
    }
}
