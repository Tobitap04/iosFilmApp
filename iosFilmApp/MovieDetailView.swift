import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    @State private var isFavorite: Bool
    @State private var showRatingPopup: Bool = false
    @State private var ratingText: String = ""
    @State private var trailerURL: String? // Neuer State für den Trailer-Link

    @ObservedObject var ratingManager: RatingManager

    init(movie: Movie, ratingManager: RatingManager) {
        self.movie = movie
        self.ratingManager = ratingManager
        let storedFavoriteStatus = UserDefaults.standard.bool(forKey: "\(movie.id)-favorite")
        _isFavorite = State(initialValue: storedFavoriteStatus)
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    // Film Cover im 2:3-Format
                    if let posterPath = movie.posterPath, !posterPath.isEmpty {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")) { image in
                            image
                                .resizable()
                                .aspectRatio(2/3, contentMode: .fill) // 2:3 Hochkantformat
                                .frame(width: 200, height: 300) // Fixiertes Format für Konsistenz
                                .clipShape(RoundedRectangle(cornerRadius: 12)) // Abgerundete Ecken
                        } placeholder: {
                            Color.gray
                                .frame(width: 200, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    } else {
                        Color.gray
                            .frame(width: 200, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // Filmtitel
                    Text(movie.title)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    // Erscheinungsdatum im deutschen Format
                    Text("Erscheinungsdatum: \(formattedDate(movie.releaseDate))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    // Zusammenfassung
                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    // Trailer und Bewertung nebeneinander
                    HStack(spacing: 20) {
                        // Trailer ansehen
                        if let trailerURL = trailerURL {
                            Text("Trailer ansehen")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    if let url = URL(string: "https://www.youtube.com/watch?v=\(trailerURL)") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }

                        // Bewerten
                        Text("Bewerten")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showRatingPopup.toggle()
                                ratingText = ratingManager.getRating(for: movie.id) ?? "Ihre Bewertung"
                            }
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .navigationBarItems(trailing: Button(action: {
                toggleFavorite()
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.title2)
            })
        }
        .sheet(isPresented: $showRatingPopup) {
            RatingPopupView(movie: movie, ratingText: $ratingText, onSave: saveRating)
        }
        .onAppear {
            // Trailer-URL abrufen
            MovieAPI.fetchMovieTrailer(movieId: movie.id) { trailerKey in
                if let key = trailerKey {
                    trailerURL = key
                }
            }
        }
    }

    private func formattedDate(_ dateString: String?) -> String {
        guard let dateString = dateString, !dateString.isEmpty else {
            return "Kein Datum verfügbar" // Fallback-Text, wenn das Datum fehlt oder leer ist
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .long
            dateFormatter.locale = Locale(identifier: "de_DE")
            return dateFormatter.string(from: date)
        }
        return dateString // Rückgabe des Originaldatums, wenn die Formatierung fehlschlägt
    }
    private func toggleFavorite() {
        isFavorite.toggle()
        UserDefaults.standard.set(isFavorite, forKey: "\(movie.id)-favorite")
    }

    private func saveRating(_ rating: String) {
        ratingManager.saveRating(rating, for: movie.id)
        ratingText = rating
        showRatingPopup.toggle()
    }
}
