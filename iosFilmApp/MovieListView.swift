import SwiftUI

struct MovieListView: View {
    @State private var movies = [Movie]()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                List(movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        HStack {
                            if let poster = movie.posterPath {
                                Image(systemName: "film.fill")
                                    .frame(width: 50, height: 75)
                            }
                            Text(movie.title)
                                .font(.headline)
                        }
                    }
                }
                .searchable(text: $searchText) // Hier ist der searchable Modifikator
                .onAppear(perform: loadMovies)
            }
            .navigationBarTitle("Movies")
        }
    }

    private func loadMovies() {
        // Call API and update movies
        let apiManager = MovieAPIManager()
        apiManager.fetchMovies { fetchedMovies in
            self.movies = fetchedMovies
        }
    }
}
