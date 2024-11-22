import SwiftUI

struct FavoritesViewController: View {
    @State private var favoriteFilms: [Film] = []

    var tabIndex: Int

    var body: some View {
        VStack {
            Text("Favoriten")
                .font(.headline)
                .foregroundColor(.white)
                .padding()

            MovieListView(films: favoriteFilms) { film in
                // Navigate to film details
            }
            .onAppear {
                // Load favorite films from storage
            }
        }
        .background(Color.black)
    }
}
