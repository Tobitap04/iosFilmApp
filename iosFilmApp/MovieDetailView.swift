import SwiftUI

struct MovieDetailView: View {
    @Binding var movie: Movie // @Binding für das Film-Objekt
    @ObservedObject var favoritesManager: FavoritesManager
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    if favoritesManager.isFavorite(movie) {
                        favoritesManager.removeFromFavorites(movie)
                    } else {
                        favoritesManager.addToFavorites(movie)
                    }
                }) {
                    Image(systemName: favoritesManager.isFavorite(movie) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                .padding()
            }
            
            // Filmdetails
            AsyncImage(url: movie.posterURL)
                .scaledToFit()
                .frame(width: 200, height: 300)
            
            Text(movie.title)
                .font(.title)
                .foregroundColor(.white)
            
            Text(movie.releaseDate ?? "Erscheinungsdatum unbekannt")
                .foregroundColor(.gray)
            
            Text(movie.overview)
                .foregroundColor(.white)
                .padding()

            Button("Bewerten") {
                // Bewertungscode hier
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Stelle sicher, dass du das Binding korrekt übergibst:
        MovieDetailView(movie: .constant(Movie(id: 1, title: "Film Title", posterPath: nil, releaseDate: "2024-01-01", overview: "Description")), favoritesManager: FavoritesManager())
    }
}
