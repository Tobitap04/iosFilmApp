import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel = MovieListViewModel()
    
    var body: some View {
        VStack {
            Text("Favoriten")
                .font(.title)
                .foregroundColor(.white)
                .padding()
            
            List(viewModel.movies) { movie in
                MovieRow(movie: movie)
            }
        }
        .background(Color.black)
    }
}
