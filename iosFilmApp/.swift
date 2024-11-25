import SwiftUI
import AVKit

struct MovieDetailView: View {
    let movie: Movie
    @State private var userReview: String = ""
    @State private var isReviewing = false
    @State private var isFavorite = false // Lokale Favoritenstatus-Variable
    @StateObject private var favoriteMoviesManager = FavoriteMoviesManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    Button("Bewerten") {
                        isReviewing.toggle()
                    }
                    .foregroundColor(.blue)
                }
                .padding()
                
                AsyncImage(url: URL(string: movie.posterPath)) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .background(Color.black)
                } placeholder: {
                    ProgressView()
                }
                
                Text(movie.title)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding([.top, .bottom], 8)
                
                Text("Erscheinungsdatum: \(movie.releaseDate)")
                    .foregroundColor(.gray)
                
                Text(movie.overview)
                    .foregroundColor(.white)
                    .padding(.top)
                
                if let trailerURL = movie.trailerURL {
                    Text("Trailer")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    VideoPlayer(player: AVPlayer(url: trailerURL))
                        .frame(height: 200)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
        }
        .sheet(isPresented: $isReviewing) {
            ReviewView(review: $userReview, movieID: movie.id)
        }
        .onAppear {
            loadUserReview()
            syncFavoriteStatus() // Synchronisiert den Favoritenstatus
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
}
