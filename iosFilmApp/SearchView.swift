import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [Movie] = []

    var body: some View {
        VStack {
            HStack {
                TextField("Titel, Schauspieler, Regisseur", text: $searchQuery)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(.black)
                    .padding()
                
                Button(action: performSearch) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
            }

            List(searchResults) { movie in
                SearchResultRow(movie: movie)
            }
        }
        .background(Color.black)
    }
    
    func performSearch() {
        APIManager.searchMovies(query: searchQuery) { result in
            switch result {
            case .success(let movies):
                self.searchResults = movies
            case .failure(let error):
                print("Error searching movies: \(error)")
            }
        }
    }
}
