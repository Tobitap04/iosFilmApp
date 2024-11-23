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
            // Favoriten- und Bewertungs-Buttons
            HStack {
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .white)
                        .font(.system(size: 24))
                        .padding()
                }
                .accessibilityLabel(isFavorite ? "Aus Favoriten entfernen" : "Zu Favoriten hinzufügen")
                
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
            }
            .padding(.horizontal)
            .background(Color.black)

            // ScrollView für den restlichen Inhalt
            ScrollView {
                VStack(spacing: 20) {
                    // Filmcover
                    AsyncImage(url: URL(string: movie.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .cornerRadius(10)
                            .clipped()
                            .padding(.top, 20)
                            .padding(.horizontal)
                    } placeholder: {
                        Color.gray
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.top, 20)
                            .padding(.horizontal)
                    }

                    // Titel und Erscheinungsdatum
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

                    // Trailer anzeigen
                    if let trailerUrlString = movie.trailerUrl, let trailerUrl = URL(string: trailerUrlString) {
                        Button(action: {
                            showTrailer.toggle()
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
                    } else {
                        Text("Kein Trailer verfügbar")
                            .foregroundColor(.gray)
                    }

                    // Zurück-Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Zurück")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
            .background(Color.black)
        }
        .background(Color.black)
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
