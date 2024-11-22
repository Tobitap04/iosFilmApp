import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        List(favoritesViewModel.favorites) { movie in
            Text(movie.title)
        }
        .navigationBarTitle("Favoriten")
    }
}
