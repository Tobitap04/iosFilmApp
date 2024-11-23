//
//  DetailView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI
import AVKit

struct DetailView: View {
    var film: Film
    @State private var isFavorit = false
    @State private var review: String = ""
    @State private var trailerURL: URL?

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: {
                        toggleFavorit()
                    }) {
                        Text(isFavorit ? "Vom Favoriten entfernen" : "Zu Favoriten hinzufügen")
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Button(action: {
                        // Bewertung Pop-up anzeigen
                    }) {
                        Text("Bewerten")
                            .foregroundColor(.white)
                    }
                }

                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(film.posterPath)")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }

                Text(film.title)
                    .foregroundColor(.white)

                Text("Erscheinungsdatum: \(film.releaseDate)")
                    .foregroundColor(.white)

                Text("Kurze Zusammenfassung...")
                    .foregroundColor(.white)

                if let trailerURL = trailerURL {
                    VideoPlayer(player: AVPlayer(url: trailerURL))
                        .frame(height: 200)
                }
            }
            .padding()
        }
        .background(Color.black)
        .onAppear {
            fetchTrailer()
        }
    }

    func toggleFavorit() {
        if isFavorit {
            CoreDataHelper.shared.deleteFilm(id: film.id)
        } else {
            CoreDataHelper.shared.saveFilm(id: film.id, title: film.title, posterPath: film.posterPath, releaseDate: film.releaseDate)
        }
        isFavorit.toggle()
    }

    func fetchTrailer() {
        let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(film.id)/videos?api_key=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            if let videoResponse = try? decoder.decode(VideoResponse.self, from: data), let trailer = videoResponse.results.first(where: { $0.type == "Trailer" }) {
                DispatchQueue.main.async {
                    self.trailerURL = URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")
                }
            }
        }.resume()
    }
}

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let type: String
}
