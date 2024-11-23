import SwiftUI

struct HomeView: View {
    @StateObject private var movieViewModel = MovieViewModel()
    @State private var category: String = "now_playing"  // Initiale Kategorie
    
    var body: some View {
        VStack {
            HStack {
                Text(category == "now_playing" ? "Aktuelle Filme" : "Zukünftige Filme")
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    // Wechseln der Kategorie
                    category = (category == "now_playing") ? "upcoming" : "now_playing"
                    movieViewModel.fetchMovies(for: category)
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            // Warten auf den Abruf von Filmen und Anzeigen in der ScrollView
            if movieViewModel.movies.isEmpty {
                Text("Lade Filme...")
                    .foregroundColor(.white)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                        ForEach(movieViewModel.movies) { movie in
                            MovieCell(movie: movie)
                        }
                    }
                }
            }
        }
        .onAppear {
            movieViewModel.fetchMovies(for: category)
        }
        .background(Color.black)
    }
}

struct MovieCell: View {
    var movie: Movie
    
    var body: some View {
        VStack {
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 150)
            
            Text(movie.title)
                .foregroundColor(.white)
                .font(.headline)
                .lineLimit(1)
            
            Text(movie.releaseDate)
                .foregroundColor(.white)
                .font(.subheadline)
        }
    }
}
