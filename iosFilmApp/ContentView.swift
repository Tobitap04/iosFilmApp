import SwiftUI

struct ContentView: View {
    @State private var showUpcoming = false
    @State private var movies: [Movie] = []
    @StateObject private var favoriteManager = FavoriteManager()
    @StateObject private var ratingManager = RatingManager() // RatingManager als StateObject

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(showUpcoming ? "Zukünftige Filme" : "Aktuelle Filme")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        showUpcoming.toggle()
                        fetchMovies()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
                .padding()

                MovieGridView(movies: movies, favoriteManager: favoriteManager, ratingManager: ratingManager) // Übergabe von ratingManager
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                fetchMovies()
            }
        }
    }
    
    private func fetchMovies() {
        let movieType = showUpcoming ? "upcoming" : "now_playing"
        // TMDB API call
        MovieAPI.fetchMovies(type: movieType) { fetchedMovies in
            DispatchQueue.main.async {
                self.movies = fetchedMovies
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
