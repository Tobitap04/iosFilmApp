import SwiftUI

struct MovieListView: View {
    @EnvironmentObject var movieViewModel: MovieViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        NavigationView {
            List(movieViewModel.movies) { movie in
                HStack {
                    // AsyncImage mit Platzhalter und Fehlerbehandlung
                    AsyncImage(url: movie.posterURL) { phase in
                        switch phase {
                        case .empty:
                            // Ladebalken oder Platzhalter, während das Bild noch geladen wird
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(width: 50, height: 75)
                        case .success(let image):
                            // Bild erfolgreich geladen
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 75)
                        case .failure:
                            // Fehlerplatzhalter anzeigen
                            Image(systemName: "photo.fill")
                                .frame(width: 50, height: 75)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }

                    Text(movie.title)
                    Spacer()
                    Button(action: {
                        favoritesViewModel.toggleFavorite(movie)
                    }) {
                        Image(systemName: favoritesViewModel.isFavorite(movie) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                movieViewModel.fetchMovies()
            }
            .navigationBarTitle("Kinofilme")
            .navigationBarItems(trailing: NavigationLink("Favoriten", destination: FavoritesView()))
        }
    }
}
