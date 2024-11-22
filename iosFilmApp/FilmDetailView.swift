import SwiftUI

struct FilmDetailView: View {
    var film: Film
    @State private var isFavorite: Bool = false
    @State private var userReview: String = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isFavorite.toggle()
                    // Speichern oder Löschen des Films in Favoriten hier implementieren
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.white)
                        .font(.title)
                }

                Spacer()

                Button(action: {
                    // Popup für die Bewertung des Films anzeigen
                    // Bewertungslogik hier implementieren
                }) {
                    Text("Bewerten")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
            .padding()

            if let posterURL = film.posterURL {
                AsyncImage(url: posterURL) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(height: 300)  // Vergrößertes Filmcover
                } placeholder: {
                    Color.gray.frame(height: 300)
                }
            }

            Text(film.title)
                .font(.title)
                .foregroundColor(.white)
                .padding(.top)

            Text(film.releaseDate)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.top)

            Text(film.overview)
                .font(.body)
                .foregroundColor(.white)
                .padding()

            Spacer()

            Button(action: {
                // Zurück zur vorherigen Ansicht
                // Logik zum Zurückkehren
            }) {
                Text("Zurück")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding(.bottom)
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)  // Optional: hides default back button
    }
}
