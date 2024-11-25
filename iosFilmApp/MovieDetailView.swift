import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    @State private var isFavorite: Bool
    @State private var showRatingPopup: Bool = false
    @State private var ratingText: String = ""
    @State private var trailerURL: String? // Neuer State für den Trailer-Link
    
    @ObservedObject var ratingManager: RatingManager // @StateObject zu @ObservedObject geändert

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
                    // Film Cover
                    if let posterPath = movie.posterPath, !posterPath.isEmpty {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 300)
                                .cornerRadius(8)
                        } placeholder: {
                            Color.gray
                                .frame(width: 200, height: 300)
                                .cornerRadius(8)
                        }
                    } else {
                        Color.gray
                            .frame(width: 200, height: 300)
                            .cornerRadius(8)
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
                        .padding(.top, 10)
                        .padding(.horizontal)
                    
                    // Trailer und Bewertung nebeneinander
                    HStack {
                        // Trailer ansehen
                        if let trailerURL = trailerURL {
                            Text("Trailer ansehen")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()
                                .onTapGesture {
                                    // Öffne den Trailer-Link
                                    if let url = URL(string: "https://www.youtube.com/watch?v=\(trailerURL)") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }
                        
                        // Bewerten
                        Text("Bewerten")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .onTapGesture {
                                showRatingPopup.toggle()
                                ratingText = ratingManager.getRating(for: movie.id) ?? "Ihre Bewertung"
                            }
                    }
                    .padding(.top, 20)
                }
                .padding()
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
                    trailerURL = key // Setze den Trailer-Link, wenn verfügbar
                }
            }
        }
    }

    private func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .long
            dateFormatter.locale = Locale(identifier: "de_DE")
            return dateFormatter.string(from: date)
        }
        return dateString
    }

    private func toggleFavorite() {
        isFavorite.toggle()
        // Favoritenstatus speichern
        UserDefaults.standard.set(isFavorite, forKey: "\(movie.id)-favorite")
    }

    private func saveRating(_ rating: String) {
        ratingManager.saveRating(rating, for: movie.id)
        ratingText = rating // Aktualisiere den Text im Popup mit der gespeicherten Bewertung
        showRatingPopup.toggle() // Schließe das Popup
    }
}
