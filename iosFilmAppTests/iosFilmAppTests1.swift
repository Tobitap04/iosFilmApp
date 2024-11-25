import XCTest
import SwiftUI
@testable import iosFilmApp

class iosFilmAppTests1: XCTestCase {
    
    var movies: [Movie]!
    var favoriteMoviesManager: FavoriteMoviesManager!
    


    
    override func setUpWithError() throws {
        super.setUp()
        movies = [
            Movie(id: 912649, title: "Venom: The Last Dance", releaseDate: "2024-10-22", overview: "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision that will bring the curtains down on Venom and Eddie's last dance.", posterPath: "/ht8Uv9QPv9y7K0RvUyJIaXOZTfd.jpg", trailerURL: URL(filePath: "https://m.youtube.com/watch?v=M0suCEhUAx0")),
            Movie(id: 1100782, title: "Zukünftiger Film", releaseDate: "2024-10-16", overview: "About to embark on a new world tour, global pop sensation Skye Riley begins experiencing increasingly terrifying and inexplicable events. Overwhelmed by the escalating horrors and the pressures of fame, Skye is forced to face her dark past to regain control of her life before it spirals out of control.", posterPath: "/ht8Uv9QPv9y7K0RvUyJIaXOZTfd.jpg", trailerURL: URL(filePath: "https://m.youtube.com/watch?v=WMtmisocnBE"))
        ]
        favoriteMoviesManager = FavoriteMoviesManager()
    }
    
    override func tearDownWithError() throws {
        movies = nil
        favoriteMoviesManager = nil
        super.tearDown()
    }
    
    
    func testFetchNowPlayingMovies() throws {
        let expectation = self.expectation(description: "Fetch now-playing movies")
        
        TMDBService.fetchMovies(category: .nowPlaying) { fetchedMovies in
            XCTAssertFalse(fetchedMovies.isEmpty, "Die aktuellen Filme sollten nicht leer sein.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchUpcomingMovies() throws {
        let expectation = self.expectation(description: "Fetch upcoming movies")
        
        TMDBService.fetchMovies(category: .upcoming) { fetchedMovies in
            XCTAssertFalse(fetchedMovies.isEmpty, "Die zukünftigen Filme sollten nicht leer sein.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testToggleMovieCategory() throws {
        // Simuliere den Zustand mit einer ViewModel-ähnlichen Struktur
        var showingUpcomingMovies = false // Startzustand
        func toggleMovieCategory() {
            showingUpcomingMovies.toggle()
        }
        let initialState = showingUpcomingMovies
        toggleMovieCategory()
        XCTAssertNotEqual(initialState, showingUpcomingMovies, "Das Umschalten zwischen Kategorien sollte den Zustand ändern.")
    }
    
    
    func testOpenDetailViewFromMovies() throws {
        let movie = movies[0]
        let detailView = MovieDetailView(movie: movie)
        XCTAssertEqual(detailView.movie.title, movie.title, "Die Detailansicht sollte den korrekten Filmtitel anzeigen.")
    }
    
    func testFetchTrailer() throws {
        let expectation = self.expectation(description: "Fetch movie trailer")
        let movieID = movies[0].id
        
        TMDBService.fetchTrailer(for: movieID) { trailerURL in
            XCTAssertNotNil(trailerURL, "Die Trailer-URL sollte nicht nil sein.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testToggleFavoriteInDetailView() throws {
        let movie = movies[0]
        //XCTAssertFalse(favoriteMoviesManager.isFavorite(movie), "Der Film sollte zunächst nicht in den Favoriten sein.")
        favoriteMoviesManager.addToFavorites(movie)
        XCTAssertTrue(favoriteMoviesManager.isFavorite(movie), "Der Film sollte nun in den Favoriten sein.")
        favoriteMoviesManager.removeFromFavorites(movie)
        XCTAssertFalse(favoriteMoviesManager.isFavorite(movie), "Der Film sollte aus den Favoriten entfernt werden.")
    }
    
    func testDetailViewContents() throws {
        let movie = movies[0]
        let detailView = MovieDetailView(movie: movie)
        XCTAssertEqual(detailView.movie.title, movie.title, "Der Titel in der Detailansicht sollte korrekt sein.")
        XCTAssertEqual(detailView.movie.releaseDate, movie.releaseDate, "Das Veröffentlichungsdatum sollte korrekt angezeigt werden.")
    }
    
   
    
    // Filmnamen ändern
    func testSearchByTitle() throws {
        let expectation = self.expectation(description: "Search movies by title")
        TMDBService.searchAll(query: "Venom: The Last Dance") { results in
            XCTAssertFalse(results.isEmpty, "Die Suchergebnisse sollten nicht leer sein.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFavoritesViewLogic() {
        favoriteMoviesManager.addToFavorites(movies[0])
        XCTAssertTrue(favoriteMoviesManager.favoriteMovies.contains { $0.id == movies[0].id }, "Der Film sollte in den Favoriten enthalten sein.")
    }
    
    func testTabSwitching() throws {
        let contentView = ContentView()
        XCTAssertNotNil(contentView.body, "Die Hauptansicht sollte korrekt geladen werden.")
    }
}

class MovieDetailViewModel: ObservableObject {
    @Published var userReview = ""
    
    func loadUserReview(for movieID: Int) {
        userReview = UserDefaults.standard.string(forKey: "\(movieID)-review") ?? ""
    }
    
    func saveUserReview(for movieID: Int) {
        UserDefaults.standard.set(userReview, forKey: "\(movieID)-review")
    }
    
    
    func testWriteCommentInDetailView() {
        let viewModel = MovieDetailViewModel()
        let movieID = 912649
        
        viewModel.userReview = "Toller Film!"
        viewModel.saveUserReview(for: movieID)
        viewModel.userReview = ""
        viewModel.loadUserReview(for: movieID)
        
        XCTAssertEqual(viewModel.userReview, "Toller Film!", "Der Kommentar sollte korrekt gespeichert und geladen werden.")
    }
}
