import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    @State private var isFavorite = false

    var body: some View {
        VStack {
            // Beispiel für das Filmcover und andere Details
            AsyncImage(url: movie.posterURL) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 200, height: 300)

            Text(movie.title)
                .font(.title)
                .padding()

            Text(movie.releaseFormatted)
                .font(.subheadline)
                .padding()

            // Favoriten Button
            Button(action: {
                if isFavorite {
                    FavoriteMovie.removeFromFavorites(movie: movie)
                } else {
                    FavoriteMovie.addToFavorites(movie: movie)
                }
                isFavorite.toggle()
            }) {
                Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    .foregroundColor(.white)
                    .padding()
                    .background(isFavorite ? Color.red : Color.green)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .onAppear {
            isFavorite = FavoriteMovie.isFavorite(movie: movie)
        }
    }
}
