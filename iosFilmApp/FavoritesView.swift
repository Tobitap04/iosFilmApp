import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        VStack {
            if favoritesViewModel.favoriteMovies.isEmpty {
                Text("Keine Favoriten vorhanden.")
                    .foregroundColor(.white)
                    .padding()
            } else {
                List(favoritesViewModel.favoriteMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieCell(movie: movie)
                    }
                }
            }
        }
        .background(Color.black)
        .navigationBarTitle("Favoriten", displayMode: .inline)
    }
}
