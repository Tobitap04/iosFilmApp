import SwiftUI

struct MovieListView: View {
    @State private var isCurrentMovies = true
    @State private var movies: [Movie] = []
    
    var body: some View {
        VStack {
            HStack {
                Text(isCurrentMovies ? "Aktuelle Filme" : "Zukünftige Filme")
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
                Button(action: toggleMovies) {
                    Image(systemName: "gear")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(movies, id: \.id) { movie in
                        MovieCard(movie: movie)
                            .onTapGesture {
                                // Navigiere zur Detailansicht
                            }
                    }
                }
                .onAppear(perform: loadMovies)
            }
        }
    }
    
    func toggleMovies() {
        isCurrentMovies.toggle()
        loadMovies()
    }
    
    func loadMovies() {
        // Hier wird die TMDB API aufgerufen, um aktuelle oder zukünftige Filme zu laden
        TMDBAPI.fetchMovies(isCurrentMovies: isCurrentMovies) { movies in
            self.movies = movies
        }
    }
}

struct MovieCard: View {
    var movie: Movie
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")) { image in
                image.resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(height: 150)
                     .clipped()
            } placeholder: {
                Color.gray
                    .frame(height: 150)
            }
            
            Text(movie.title)
                .foregroundColor(.white)
                .font(.subheadline)
                .padding(.top, 5)
        }
        .background(Color.gray)
        .cornerRadius(10)
        .padding(5)
    }
}