import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List(filteredMovies) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    HStack {
                        if let url = movie.posterURL {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 50, height: 75)
                            .cornerRadius(8)
                        }
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.releaseDate)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Movies")
            .searchable(text: $searchText, prompt: "Search movies")
            .onAppear {
                viewModel.fetchMovies()
            }
        }
    }

    // Filter die Filme basierend auf dem Suchtext
    private var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return viewModel.movies
        } else {
            return viewModel.movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private let service = MovieService()
    
    func fetchMovies() {
        service.fetchMovies(endpoint: "now_playing") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                }
            }
        }
    }
}
