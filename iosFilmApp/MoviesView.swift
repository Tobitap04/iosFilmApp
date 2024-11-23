import SwiftUI

struct MoviesView: View {
    @State private var movies: [Movie] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Aktuelle Filme")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                }
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                        ForEach(movies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                VStack {
                                    AsyncImage(url: URL(string: movie.imageUrl)) { image in
                                        image.resizable()
                                             .scaledToFit()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(height: 150)
                                    .cornerRadius(8)
                                    
                                    Text(movie.title)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .onAppear {
                loadMovies()
            }
        }
    }
    
    func loadMovies() {
        isLoading = true
        TMDBService().fetchMovies(endpoint: "now_playing") { movies in
            DispatchQueue.main.async {
                self.movies = movies
                self.isLoading = false
            }
        }
    }
}
