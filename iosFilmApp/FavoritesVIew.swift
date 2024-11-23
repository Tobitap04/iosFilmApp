import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesManager: FavoritesManager
    @State private var selectedMovie: Movie? // Movie bleibt optional

    var body: some View {
        NavigationView {
            List(favoritesManager.favorites) { movie in
                NavigationLink(
                    destination: MovieDetailView(
                        movie: Binding(
                            get: { selectedMovie ?? movie }, // Den Wert von selectedMovie oder movie verwenden
                            set: { selectedMovie = $0 } // Den Wert von selectedMovie aktualisieren
                        ),
                        favoritesManager: favoritesManager
                    )
                ) {
                    HStack {
                        if let posterURL = movie.posterURL {
                            AsyncImage(url: posterURL) { image in
                                image.resizable()
                                     .scaledToFit()
                                     .frame(width: 50, height: 75)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.releaseDate ?? "Unbekannt") // Optional mit ?? entpacken
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Favoriten")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(favoritesManager: FavoritesManager())
    }
}
