import SwiftUI
import AVKit

struct MovieDetailView: View {
    let movie: Movie
    @State private var isFavorite: Bool = false
    @State private var userReview: String = ""
    @State private var isReviewing: Bool = false
    @State private var showTrailer: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>  // Für den Zurück-Button

    var body: some View {
        VStack {
            // Favoriten- und Bewerten Buttons oben fest positioniert mit schwarzem Hintergrund
            HStack {
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .white)
                        .font(.system(size: 24))
                        .padding()
                }
                .accessibilityLabel(isFavorite ? "Aus Favoriten entfernen" : "Zu Favoriten hinzufügen")
                .accessibilityHint("Markiert diesen Film als Favorit oder entfernt ihn aus der Favoritenliste.")
                
                Spacer()
                
                Button(action: {
                    isReviewing = true
                }) {
                    Text("Bewerten")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                }
                .accessibilityLabel("Film bewerten")
                .accessibilityHint("Ermöglicht es, eine Bewertung für diesen Film hinzuzufügen oder zu bearbeiten.")
            }
            .padding(.horizontal)
            .background(Color.black)  // Setzt den Hintergrund der Buttons auf Schwarz
            .zIndex(1)  // Sicherstellen, dass diese oben sind

            // ScrollView für den restlichen Inhalt
            ScrollView {
                VStack(spacing: 20) {
                    // Filmcover - mittig und ohne weiße Linie, aber mit Scrollverhalten
                    AsyncImage(url: URL(string: movie.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit() // Bild wird richtig skaliert
                            .frame(width: 200) // Bildgröße verkleinern
                            .cornerRadius(10)
                            .clipped()
                            .padding(.top, 20) // Leichter Abstand nach oben
                            .padding(.horizontal)
                    } placeholder: {
                        Color.gray
                            .frame(height: 200) // Platzhalterhöhe für das Bild
                            .cornerRadius(10)
                            .padding(.top, 20)
                            .padding(.horizontal)
                    }

                    // Titel und Erscheinungsdatum mittig anzeigen
                    Text(movie.title)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 5)

                    Text("Erscheinungsdatum: \(movie.releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Beschreibung
                    Text(movie.overview)
                        .foregroundColor(.white)
                        .font(.body)
                        .padding(.top, 10)
                        .padding(.horizontal)

                    // Trailer anzeigen, wenn vorhanden
                    if let trailerUrlString = movie.getTrailerUrl(), let trailerUrl = URL(string: trailerUrlString) {
                        Button(action: {
                            showTrailer.toggle() // Trailer abspielen
                        }) {
                            Text("Trailer ansehen")
                                .foregroundColor(.blue)
                                .font(.headline)
                                .padding()
                        }
                        .padding(.horizontal)

                        if showTrailer {
                            VideoPlayer(player: AVPlayer(url: trailerUrl))
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }

                    // Zurück-Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()  // Zurück-Navigation
                    }) {
                        Text("Zurück")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)  // Etwas Abstand nach dem Zurück-Button
                }
                .padding(.horizontal)
            }
            .background(Color.black)  // Hintergrund des ScrollView auf Schwarz setzen
        }
        .background(Color.black) // Der gesamte Hintergrund soll schwarz sein
        .onAppear {
            isFavorite = FavoriteManager.shared.isFavorite(movie: movie)
            userReview = ReviewManager.shared.getReview(for: movie) ?? ""
        }
        .sheet(isPresented: $isReviewing) {
            ReviewView(movie: movie, currentReview: $userReview)
        }
    }

    func toggleFavorite() {
        if isFavorite {
            FavoriteManager.shared.removeFavorite(movie: movie)
        } else {
            FavoriteManager.shared.addFavorite(movie: movie)
        }
        isFavorite.toggle()
    }
}
