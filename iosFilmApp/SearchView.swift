import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @ObservedObject var viewModel = MovieListViewModel()
    
    var body: some View {
        VStack {
            TextField("Titel, Schauspieler, Regisseur", text: $searchQuery)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .padding()
            
            Button(action: {
                viewModel.fetchMovies(for: .current)
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
            }
            
            List(viewModel.movies) { movie in
                MovieRow(movie: movie)
            }
        }
        .background(Color.black)
        .onChange(of: searchQuery) { newValue in
            if newValue.count > 2 {
                viewModel.movieService.searchMovies(query: newValue) { movies in
                    DispatchQueue.main.async {
                        viewModel.movies = movies ?? []
                    }
                }
            }
        }
    }
}
