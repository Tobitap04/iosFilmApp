import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel

    var body: some View {
        VStack {
            TextField("Suchbegriff", text: $searchViewModel.query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            List(searchViewModel.movies) { movie in
                Text(movie.title)
            }
        }
        .onChange(of: searchViewModel.query) { _ in
            searchViewModel.searchMovies()
        }
    }
}
