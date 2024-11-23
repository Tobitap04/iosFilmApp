import SwiftUI

struct MovieListView: View {
    @State private var movies: [Movie] = []
    @State private var isCurrentMovies: Bool
    
    init(isCurrentMovies: Bool) {
        _isCurrentMovies = State(initialValue: isCurrentMovies)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(isCurrentMovies ? "Aktuelle Filme" : "Zukünftige Filme")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    isCurrentMovies.toggle() // Toggle zwischen aktuellen und zukünftigen Filmen
                    fetchMovies()  // Bei Änderung der Auswahl werden Filme neu abgerufen
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            // Anzeige der Filme
            if movies.isEmpty {
                Text("Lade Filme...")
                    .foregroundColor(.white)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                        ForEach(movies) { movie in
                            VStack {
                                if let url = movie.posterURL {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                             .scaledToFit()
                                             .frame(width: 100, height: 150)
                                             .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                Text(movie.title)
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .padding()
                            .background(Color.black)
                            .cornerRadius(12)
                            .onTapGesture {
                                // Navigation zur Detailansicht des Films
                            }
                        }
                    }
                }
                .padding([.top, .horizontal])
            }
        }
        .onAppear {
            fetchMovies()  // Beim Erscheinen der View werden die Filme geladen
        }
    }
    
    func fetchMovies() {
        TMDBAPI.fetchMovies(isCurrentMovies: isCurrentMovies) { fetchedMovies in
            DispatchQueue.main.async {
                self.movies = fetchedMovies
            }
        }
    }
}
