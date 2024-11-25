//
//  MovieDetailView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 25.11.24.
//

import SwiftUI
import AVKit

struct MovieDetailView: View {
    let movie: Movie
    @State private var userReview: String = ""
    @State private var isReviewing = false
    @State private var isFavorite = false // Lokale Favoritenstatus-Variable
    @State private var trailerURL: URL? // Dynamische Trailer-URL
    @StateObject private var favoriteMoviesManager = FavoriteMoviesManager()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    // Poster-Bild mit abgerundeten Ecken
                    AsyncImage(url: URL(string: movie.posterPath)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .cornerRadius(10) // Abgerundete Ecken
                            .background(Color.black)
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    }

                    // Filmtitel
                    Text(movie.title)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding([.top, .bottom], 8)

                    // Erscheinungsdatum
                    Text("Erscheinungsdatum: \(formatDate(movie.releaseDate))")
                        .foregroundColor(.gray)

                    // Filmübersicht
                    Text(movie.overview)
                        .foregroundColor(.white)
                        .padding(.top)

                    // Bewertungs- und Trailer-Buttons
                    HStack(spacing: 20) {
                        Spacer()

                        // Bewertungsbutton
                        Button(action: {
                            isReviewing.toggle()
                        }) {
                            Label("Bewerten", systemImage: "pencil")
                        }
                        .foregroundColor(.blue)

                        // Trailer-Button
                        Button(action: {
                            if let trailerURL = trailerURL {
                                UIApplication.shared.open(trailerURL) // Öffnet Safari mit der Trailer-URL
                            } else {
                                print("Trailer-URL nicht verfügbar.")
                            }
                        }) {
                            Label("Trailer ansehen", systemImage: "play.rectangle")
                        }
                        .foregroundColor(.green)

                        Spacer()
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .background(Color.black.ignoresSafeArea()) // Hintergrund komplett schwarz
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Favoriten-Button oben rechts fixiert
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .white) // Gelb für Favoriten, sonst weiß
                }
            }
        }
        .sheet(isPresented: $isReviewing) {
            ReviewView(review: $userReview, movieID: movie.id)
        }
        .onAppear {
            loadUserReview()
            syncFavoriteStatus()
            fetchTrailerURL() // Lädt die Trailer-URL
        }
    }

    private func fetchTrailerURL() {
        TMDBService.fetchTrailer(for: movie.id) { url in
            DispatchQueue.main.async {
                trailerURL = url
            }
        }
    }

    private func toggleFavorite() {
        if isFavorite {
            favoriteMoviesManager.removeFromFavorites(movie)
        } else {
            favoriteMoviesManager.addToFavorites(movie)
        }
        isFavorite.toggle() // Aktualisiert den lokalen Favoritenstatus
    }

    private func syncFavoriteStatus() {
        isFavorite = favoriteMoviesManager.isFavorite(movie)
    }

    private func loadUserReview() {
        userReview = UserDefaults.standard.string(forKey: "\(movie.id)-review") ?? ""
    }

    private func formatDate(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dateObj = formatter.date(from: date) {
            formatter.locale = Locale(identifier: "de_DE")
            formatter.dateStyle = .long
            return formatter.string(from: dateObj)
        }
        return date
    }
}
