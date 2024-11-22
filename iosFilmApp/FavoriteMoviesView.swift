import SwiftUI

struct FavoriteMoviesView: View {
    @FetchRequest(entity: MovieComment.entity(), sortDescriptors: [])
    private var favorites: FetchedResults<MovieComment>
    
    var body: some View {
        List {
            ForEach(favorites, id: \.self) { favorite in
                Text(favorite.text ?? "No comment")
            }
        }
        .navigationTitle("Favorites")
    }
}
