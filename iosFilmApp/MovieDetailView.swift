import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var favoritesManager = FavoritesManager()
    @State private var userReview: String = ""
    @State private var isReviewPopupVisible = false
    
    var body: some View {
        VStack {
            // Favoriten- und Bewerten-Buttons
            HStack {
                Button(action: toggleFavorite) {
                    Image(systemName: favoritesManager.favorites.contains(where: { $0.id == movie.id }) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                Spacer()
                Button(action: { isReviewPopupVisible = true }) {
                    Text("Bewerten")
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            // Film-Details
            ScrollView {
                VStack {
                    // Film-Cover
                    AsyncImage(url: URL(string: movie.imageUrl)) { image in
                        image.resizable()
                             .scaledToFit()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 300)
                    
                    // Titel und weitere Infos
                    Text(movie.title)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    Text("Erscheinungsdatum: \(movie.releaseDate)")
                        .foregroundColor(.gray)
                    
                    Text(movie.overview)
                        .foregroundColor(.white)
                        .padding()
                }
            }
            
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .sheet(isPresented: $isReviewPopupVisible) {
            ReviewPopup(review: $userReview)
        }
    }
    
    func toggleFavorite() {
        if favoritesManager.favorites.contains(where: { $0.id == movie.id }) {
            favoritesManager.removeFavorite(movie: movie)
        } else {
            favoritesManager.addFavorite(movie: movie)
        }
    }
}

struct ReviewPopup: View {
    @Binding var review: String
    
    var body: some View {
        VStack {
            Text("Bewertung verfassen")
                .font(.headline)
                .padding()
            TextField("Deine Bewertung", text: $review)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Fertig") {
                // Popup schließen
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8).ignoresSafeArea())
    }
}
