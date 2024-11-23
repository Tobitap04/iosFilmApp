import SwiftUI

struct FavoritesView: View {
    @State private var favoriteMovies: [FavoriteMovie] = []
    
    var body: some View {
        VStack {
            Text("Favoriten")
                .font(.title)
                .foregroundColor(.white)
            
            List(favoriteMovies, id: \.id) { movie in
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
                }
                .onTapGesture {
                    // Navigiere zur Detailansicht
                }
            }
        }
        .onAppear {
            // Hier werden die Favoriten des Nutzers geladen
            loadFavorites()
        }
    }
    
    func loadFavorites() {
        // Lade die Favoriten vom Speicher oder von der Datenbank
        self.favoriteMovies = FavoriteMovie.loadFavorites()
    }
}