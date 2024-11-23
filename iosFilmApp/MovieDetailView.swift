import SwiftUI
import AVKit

struct MovieDetailView: View {
    let movie: Movie
    @State private var isFavorite: Bool = false
    @State private var userRating: String = ""
    @State private var showRatingAlert: Bool = false
    @ObservedObject var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                    Spacer()
                    Button(action: {
                        showRatingAlert.toggle()
                    }) {
                        Text("Bewerten")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding()

                // Filmposter mit AsyncImage
                if let posterPath = movie.poster_path, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                    AsyncImage(url: posterURL) { image in
                        image.resizable()
                             .scaledToFit()
                             .frame(width: 300, height: 450)
                             .padding()
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 300, height: 450)
                    }
                }

                Text(movie.title)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)

                Text("Erscheinungsdatum: \(movie.release_date)")
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text(movie.overview)
                    .foregroundColor(.white)
                    .padding()

                // Trailer Video (Check if trailer URL is valid)
                if let trailerURLString = movie.trailer, let trailerURL = URL(string: trailerURLString) {
                    VideoPlayer(player: AVPlayer(url: trailerURL))
                        .frame(height: 300)
                        .padding()
                } else {
                    Text("Kein Trailer verfügbar")
                        .foregroundColor(.white)
                        .padding()
                }

                Spacer()
            }
        }
        .background(Color.black)
        .alert(isPresented: $showRatingAlert) {
            Alert(
                title: Text("Bewertung abgeben"),
                message: Text("Bitte gib deine Bewertung ein."),
                primaryButton: .default(Text("Fertig"), action: submitRating),
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            // Check if the movie is already a favorite
            isFavorite = favoritesViewModel.favoriteMovies.contains { $0.id == movie.id }
        }
    }

    private func toggleFavorite() {
        if isFavorite {
            favoritesViewModel.removeFavorite(movie: movie)
        } else {
            favoritesViewModel.addFavorite(movie: movie)
        }
        isFavorite.toggle()
    }

    private func submitRating() {
        // Save rating logic
        print("User Rating: \(userRating)")
        userRating = ""
    }
}
