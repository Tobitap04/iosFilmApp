import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack {
            // Bild wird auf feste Höhe und Breite gesetzt
            if let posterPath = movie.fullPosterPath, let url = URL(string: posterPath) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill() // Bild auf Containergröße zuschneiden
                        .frame(width: 100, height: 150) // Feste Bildgröße
                        .cornerRadius(10)
                        .clipped() // Clipped, um das Bild innerhalb des Rahmens zu halten
                } placeholder: {
                    Color.gray
                        .frame(width: 100, height: 150)
                        .cornerRadius(10)
                        .clipped()
                }
            } else {
                Color.gray
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
                    .clipped()
            }

            // Der Titel und das Datum werden jetzt unterhalb des Bildes angezeigt
            VStack {
                Text(movie.title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center) // Titel mittig ausrichten

                if let releaseDate = movie.releaseDate {
                    Text(formatDate(releaseDate))
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center) // Datum mittig ausrichten
                }
            }
            .padding(.top, 5)
            .frame(maxWidth: .infinity) // Titel und Datum nehmen die gesamte Breite ein und sind mittig
        }
        .frame(width: 100, height: 250) // Feste Höhe und Breite für die gesamte Karte
        .padding(.bottom)
        .background(Color.black)
        .cornerRadius(10)
    }

    // Funktion, um das amerikanische Datum in ein deutsches Format zu konvertieren
    private func formatDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd.MM.yyyy" // Deutsches Format
            return dateFormatter.string(from: date)
        }
        return date
    }
}
