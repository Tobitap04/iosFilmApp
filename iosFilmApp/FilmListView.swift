import SwiftUI

enum MovieType {
    case nowPlaying, upcoming
}

struct FilmListView: View {
    var title: String
    var movieType: MovieType
    @State private var movies: [Movie] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: toggleMovieType) {
                    Image(systemName: "gear")
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(movies) { movie in
                        MovieCard(movie: movie)
                    }
                }
            }
        }
        .background(Color.black)
        .onAppear {
            loadMovies()
        }
    }
    
    func toggleMovieType() {
        movieType == .nowPlaying ? loadMovies(for: .upcoming) : loadMovies(for: .nowPlaying)
    }

    func loadMovies(for type: MovieType = .nowPlaying) {
        isLoading = true
        APIManager.fetchMovies(type: type) { result in
            switch result {
            case .success(let movies):
                self.movies = movies
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
            isLoading = false
        }
    }
}
