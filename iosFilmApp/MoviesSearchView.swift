import SwiftUI

struct MovieSearchView: View {
    @State private var searchText = ""
    @State private var searchResults = [Movie]()

    var body: some View {
        VStack {
            SearchBar(text: $searchText) // Hier verwenden wir die benutzerdefinierte SearchBar
                .padding()
            
            List(searchResults) { movie in
                Text(movie.title)
            }
            .onChange(of: searchText) { newValue in
                // Wenn der Suchtext geändert wird, Filme suchen
                if !newValue.isEmpty {
                    searchMovies(query: newValue)
                } else {
                    searchResults = [] // Leere Ergebnisse, wenn die Suche zurückgesetzt wird
                }
            }
        }
    }

    private func searchMovies(query: String) {
        let apiManager = MovieAPIManager()
        apiManager.searchMovies(query: query) { movies in
            DispatchQueue.main.async {
                self.searchResults = movies
            }
        }
    }
}
