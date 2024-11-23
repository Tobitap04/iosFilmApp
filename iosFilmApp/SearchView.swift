import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [Movie] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Suche")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top)
                
                // Suchfeld
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Titel, Schauspieler, Regisseur", text: $searchText, onCommit: searchMovies)
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Ladeindikator
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                }
                
                // Suchergebnisse
                ScrollView {
                    LazyVStack {
                        ForEach(searchResults) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                HStack {
                                    AsyncImage(url: URL(string: movie.imageUrl)) { image in
                                        image.resizable()
                                             .scaledToFit()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(movie.title)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Text(movie.releaseDate)
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
    
    // Funktion für die Suche
    func searchMovies() {
        guard !searchText.isEmpty else {
            self.searchResults = []
            return
        }
        
        isLoading = true
        TMDBService().fetchSearchResults(query: searchText) { movies in
            DispatchQueue.main.async {
                self.searchResults = movies
                self.isLoading = false
            }
        }
    }

}
