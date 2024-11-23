import SwiftUI

struct FavoritesView: View {
    @State private var favorites: [Movie] = []

    var body: some View {
        VStack {
            Text("Favoriten")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()

            List(favorites) { movie in
                MovieCard(movie: movie)
            }
        }
        .background(Color.black)
        .onAppear {
            favorites = RatingManager.getFavorites()
        }
    }
}

struct MovieCard: View {
    var movie: Movie

    var body: some View {
        HStack {
            // Füge hier das Filmcover hinzu
            Image(systemName: "film.fill") // Dummy Image - Ersetze es mit einem echten Bild
                .resizable()
                .frame(width: 50, height: 75)
                .cornerRadius(5)

            Text(movie.title)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Spacer()
            
            // Nil-Coalescing-Operator, um einen Standardwert zu setzen, wenn releaseDate nil ist
            Text(movie.releaseDate ?? "Unbekannt")
                .foregroundColor(.gray)
                .font(.footnote)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
            // Navigation zur Detailansicht
        }
    }
}
