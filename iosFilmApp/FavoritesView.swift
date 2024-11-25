import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoriteMoviesManager = FavoriteMoviesManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Favoriten")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                
                if favoriteMoviesManager.favoriteMovies.isEmpty {
                    Text("Keine gespeicherten Filme.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                            ForEach(favoriteMoviesManager.favoriteMovies) { movie in
                                NavigationHelper.navigateToDetail(
                                    movie: movie,
                                    from: VStack {
                                        AsyncImage(url: URL(string: movie.posterPath)) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(12) // Abrundung der Ecken
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(height: 150)
                                        
                                        Text(movie.title)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                )
                            }
                        }
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
        }
        .onAppear {
            favoriteMoviesManager.loadFavorites()
        }
    }
}
