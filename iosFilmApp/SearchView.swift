import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
    @State private var searchResults: [Movie] = []
    @State private var isSearching = false
    
    var body: some View {
        VStack {
            // Überschrift
            Text("Suche")
                .font(.title)
                .foregroundColor(.white)
                .padding(.top)
            
            // Suchfeld
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Titel, Schauspieler, Regisseur", text: $query, onCommit: searchMovies)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .padding()
            
            // Ergebnisse anzeigen
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(searchResults) { movie in
                        HStack {
                            // Film-Cover
                            AsyncImage(url: URL(string: movie.imageUrl)) { image in
                                image.resizable()
                                     .scaledToFit()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 50, height: 75)
                            .cornerRadius(8)
                            
                            // Titel und Erscheinungsdatum
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(movie.releaseDate)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            // Pfeil für Navigation
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                            // Navigiere zur Detailansicht
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    func searchMovies() {
        guard !query.isEmpty else { return }
        isSearching = true
        TMDBService().searchMovies(query: query) { results in
            DispatchQueue.main.async {
                self.searchResults = results
                self.isSearching = false
            }
        }
    }
}
