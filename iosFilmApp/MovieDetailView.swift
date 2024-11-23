import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    @State private var isFavorite = false
    @State private var userRating: String?

    var body: some View {
        VStack {
            HStack {
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }

                Spacer()

                Button(action: openRatingModal) {
                    Text("Bewerten")
                        .foregroundColor(.white)
                }
            }
            .padding()

            Image(systemName: "film.fill")
                .resizable()
                .frame(width: 200, height: 300)

            Text(movie.title)
                .foregroundColor(.white)
                .font(.title)

            // Nil-Coalescing-Operator, um einen Standardwert zu setzen, wenn releaseDate nil ist
            Text(movie.releaseDate ?? "Unbekannt")
                .foregroundColor(.gray)

            Text(movie.overview)
                .foregroundColor(.white)

            Spacer()

            // Navigation zur MovieTrailerView hinzugefügt
            NavigationLink("Zum Trailer", destination: MovieTrailerView(movie: movie))

            Button("Zurück") {
                // Zurück zur vorherigen Ansicht
            }
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
    }

    func toggleFavorite() {
        isFavorite.toggle()
        RatingManager.updateFavorites(movie: movie, isFavorite: isFavorite)
    }

    func openRatingModal() {
        // Bewertungs-Modal öffnen
    }
}

struct MovieTrailerView: View {
    var movie: Movie

    var body: some View {
        VStack {
            // Beispiel für eingebetteten Trailer (Platzhalter)
            Text("Trailer für \(movie.title)")
                .foregroundColor(.white)
                .font(.headline)
            
            // Hier könnte ein eingebetteter Trailer-Player eingefügt werden
            Text("Trailer Video wird hier angezeigt...")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Color.black)
            
            Spacer()
        }
        .padding()
        .background(Color.black)
    }
}
