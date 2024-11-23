import SwiftUI

struct FavoritesView: View {
    @State private var favoriteMovies: [Movie] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Favoriten")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top)
                
                ScrollView {
                    LazyVStack {
                        ForEach(favoriteMovies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                HStack {
                                    AsyncImage(url: URL(string: movie.imageUrl)) { image in
                                        image.resizable()
                                             .scaledToFit()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(movie.title)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Text(movie.releaseDate)
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
            .onAppear {
                favoriteMovies = FavoriteManager.shared.getFavorites()
            }
        }
    }
}
