import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [Movie] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8) // Platzierung der Lupe
                        
                        TextField("Titel, Schauspieler, Regisseur", text: $searchQuery)
                            .foregroundColor(.black)
                            .onChange(of: searchQuery) { _ in
                                performSearch() // Automatische Suche bei Texteingabe
                            }
                            .padding(.vertical, 10)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
                }
                
                ScrollView {
                    ForEach(searchResults) { movie in
                        NavigationHelper.navigateToDetail(
                            movie: movie,
                            from: HStack {
                                AsyncImage(url: URL(string: movie.posterPath)) { image in
                                    image.resizable()
                                        .frame(width: 50, height: 75)
                                        .cornerRadius(4)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(movie.title)
                                        .foregroundColor(.white)
                                        .bold()
                                    Text(movie.releaseDate)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        )
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarHidden(true) // Entfernt die standardmäßige Navigation-Bar
        }
    }
    
    private func performSearch() {
        TMDBService.searchMovies(query: searchQuery) { results in
            searchResults = results
        }
    }
}
