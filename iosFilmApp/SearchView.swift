import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [Movie] = []
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Titel, Schauspieler, Regisseur", text: $searchText)
                    .foregroundColor(.black)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 8)
                
                Button(action: performSearch) {
                    Text("Suchen")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            List(searchResults, id: \.id) { movie in
                HStack {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 50, height: 75)
                             .clipped()
                    } placeholder: {
                        Color.gray
                            .frame(width: 50, height: 75)
                    }
                    
                    Text(movie.title)
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                    Text(movie.releaseDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    // Navigiere zur Detailansicht
                }
            }
        }
    }
    
    func performSearch() {
        TMDBAPI.searchMovies(query: searchText) { movies in
            self.searchResults = movies
        }
    }
}