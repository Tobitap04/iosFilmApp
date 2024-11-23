import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesManager: FavoritesManager

    var body: some View {
        VStack {
            List(favoritesManager.favorites) { movie in
                Text(movie.title)
            }
        }
    }
}
