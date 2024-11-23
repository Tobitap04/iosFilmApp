
import SwiftUI

struct MoviesView: View {
    enum MovieType {
        case currentMovies
        case upcomingMovies
    }
    
    @State private var currentMovies: [Movie] = []
    @State private var isLoading = true
    @State private var type: MovieType  // @State hinzugefügt, um den Zustand zu ändern
    
    init(type: MovieType) {
        _type = State(initialValue: type)  // Initialisieren der State-Eigenschaft
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(type == .currentMovies ? "Aktuelle Filme" : "Zukünftige Filme")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                Spacer()
                
                Button(action: toggleMovies) {
                    Image(systemName: "gear")
                        .foregroundColor(.white)
                        .padding()
                }
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
            } else {
                if currentMovies.isEmpty {
                    Text("Keine Filme verfügbar.")  // Wenn keine Filme geladen wurden
                        .foregroundColor(.white)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(currentMovies) { movie in
                                MovieCell(movie: movie)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .background(Color.black)
        .onAppear {
            loadMovies()
        }
    }
    
    private func loadMovies() {
        isLoading = true
        
        print("Lade Filme...")  // Debugging-Ausgabe
        
        switch type {
        case .currentMovies:
            MovieService.getCurrentMovies { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movies):
                        print("Erfolgreich aktuelle Filme geladen: \(movies.count) Filme")  // Debugging-Ausgabe
                        currentMovies = movies
                    case .failure:
                        print("Fehler beim Abrufen der aktuellen Filme.")  // Debugging-Ausgabe
                        currentMovies = []
                    }
                    isLoading = false
                }
            }
        case .upcomingMovies:
            MovieService.getUpcomingMovies { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movies):
                        print("Erfolgreich zukünftige Filme geladen: \(movies.count) Filme")  // Debugging-Ausgabe
                        currentMovies = movies
                    case .failure:
                        print("Fehler beim Abrufen der zukünftigen Filme.")  // Debugging-Ausgabe
                        currentMovies = []
                    }
                    isLoading = false
                }
            }
        }
    }
    
    private func toggleMovies() {
        // Hier kannst du zusätzliche Logik hinzufügen, um den Typ zwischen aktuellen und zukünftigen Filmen umzuschalten
        if type == .currentMovies {
            type = .upcomingMovies
        } else {
            type = .currentMovies
        }
        
        loadMovies() // Beim Wechseln den Filmmodus neu laden
    }
}

struct MovieCell: View {
    var movie: Movie
    
    var body: some View {
        VStack {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 120, height: 180)
            .cornerRadius(10)
            
            Text(movie.title)
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding([.leading, .trailing], 5)
            
            Text("Ersch. am: \(movie.releaseDate)")
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView(type: .currentMovies)
            .preferredColorScheme(.dark)
    }
}
