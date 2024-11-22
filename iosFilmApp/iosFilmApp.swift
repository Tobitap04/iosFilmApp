import SwiftUI

@main
struct iosFilmApp: App {
    @StateObject private var movieViewModel = MovieViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            MovieListView()
                .environmentObject(movieViewModel)
                .environmentObject(favoritesViewModel)
        }
    }
}
