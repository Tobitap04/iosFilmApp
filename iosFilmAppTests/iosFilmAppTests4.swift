import XCTest
import SwiftUI
@testable import iosFilmApp

final class ReviewAndMovieDetailViewTests: XCTestCase {

    // MARK: - Properties
    var favoriteMoviesManager: FavoriteMoviesManager!
    var movie: Movie!
    var reviewView: ReviewView!
    var movieDetailView: MovieDetailView!

    override func setUp() {
        super.setUp()

        // Initialisiere Movie und Manager
        favoriteMoviesManager = FavoriteMoviesManager()
        movie = Movie(
            id: 912649,
            title: "Venom: The Last Dance",
            releaseDate: "2024-10-22",
            overview: "Eddie and Venom are on the run...",
            posterPath: "/ht8Uv9QPv9y7K0RvUyJIaXOZTfd.jpg",
            trailerURL: URL(string: "https://m.youtube.com/watch?v=M0suCEhUAx0")
        )

        // Initialisiere Views
        let reviewBinding = Binding.constant("")
        reviewView = ReviewView(review: reviewBinding, movieID: movie.id)
        movieDetailView = MovieDetailView(movie: movie, favoriteMoviesManager: self.favoriteMoviesManager)
    }

    override func tearDown() {
        super.tearDown()
        favoriteMoviesManager = nil
        movie = nil
        reviewView = nil
        movieDetailView = nil
    }

    // MARK: - Tests für ReviewView

    func testReviewViewInitialState() {
        XCTAssertEqual(reviewView.$review.wrappedValue, "", "Die Bewertung sollte initial leer sein.")
    }

   


    // MARK: - Tests für MovieDetailView

    func testMovieDetailViewInitialFavoriteState() {
        XCTAssertFalse(favoriteMoviesManager.isFavorite(movie), "Der Film sollte anfangs kein Favorit sein.")
    }

    

    func testMovieDetailViewTrailerButtonOpensURL() {
        let expectation = XCTestExpectation(description: "URL sollte geöffnet werden.")
        
        movieDetailView.trailerURL = movie.trailerURL
        UIApplication.shared.open(movie.trailerURL!) { success in
            XCTAssertTrue(success, "Die Trailer-URL sollte erfolgreich geöffnet werden.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testMovieDetailViewFormatDate() {
        let formattedDate = movieDetailView.formatDate(movie.releaseDate)
        XCTAssertEqual(formattedDate, "22. Oktober 2024", "Das Datum sollte korrekt formatiert sein.")
    }

    func testMovieDetailViewDisplayDetails() {
        XCTAssertEqual(movieDetailView.movie.title, "Venom: The Last Dance", "Der Filmtitel sollte korrekt angezeigt werden.")
        XCTAssertEqual(movieDetailView.movie.overview, "Eddie and Venom are on the run...", "Die Beschreibung sollte korrekt sein.")
        XCTAssertNotNil(movieDetailView.movie.posterPath, "Das Poster sollte vorhanden sein.")
    }
}


class ReviewViewTests: XCTestCase {
    
    func testInitialReviewTextIsEmpty() {
        let movieID = 1
        let reviewBinding = Binding.constant("")
        let view = ReviewView(review: reviewBinding, movieID: movieID)
        
        XCTAssertEqual(reviewBinding.wrappedValue, "")
    }
    
    func testReviewSaving() {
        let movieID = 123
        let reviewBinding = Binding.constant("Great movie!")
        let view = ReviewView(review: reviewBinding, movieID: movieID)
        
        view.saveReview()
        let savedReview = UserDefaults.standard.string(forKey: "\(movieID)-review")
        XCTAssertEqual(savedReview, "Great movie!")
    }
    
    func testReviewViewInitialState() {
        let reviewBinding = Binding.constant("")
        let view = ReviewView(review: reviewBinding, movieID: 1)

        XCTAssertEqual(reviewBinding.wrappedValue, "", "Initial review text should be empty.")
    }

    func testSaveEmptyReview() {
        let reviewBinding = Binding.constant("")
        let view = ReviewView(review: reviewBinding, movieID: 1)

        view.saveReview()
        let savedReview = UserDefaults.standard.string(forKey: "1-review")
        XCTAssertEqual(savedReview, "", "Saving an empty review should store an empty string.")
    }

}


class MovieDetailViewTests1: XCTestCase {
    
    var movie: Movie!
    var favoriteMoviesManager: FavoriteMoviesManager!
    
    override func setUp() {
        super.setUp()
        movie = Movie(
            id: 1,
            title: "Test Movie",
            releaseDate: "2024-01-01",
            overview: "This is a test movie.",
            posterPath: "https://example.com/poster.jpg",
            trailerURL: nil
        )
        favoriteMoviesManager = FavoriteMoviesManager()
    }

    func testMovieDetailUIElements() {
        let detailView = MovieDetailView(movie: movie, favoriteMoviesManager: self.favoriteMoviesManager)

        XCTAssertEqual(detailView.movie.title, "Test Movie", "Movie title should be displayed correctly.")
        XCTAssertEqual(detailView.movie.overview, "This is a test movie.", "Movie overview should be displayed correctly.")
    }
    
    func testDateFormatting() {
        let detailView = MovieDetailView(movie: movie)
        let formattedDate = detailView.formatDate("2024-01-01")
        XCTAssertEqual(formattedDate, "1. Januar 2024")
    }
}
