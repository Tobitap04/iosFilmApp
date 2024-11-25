import SwiftUI

struct MovieGridView: View {
    var movies: [Movie]
    @ObservedObject var favoriteManager: FavoriteManager
    @ObservedObject var ratingManager: RatingManager // Füge ratingManager hier hinzu
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie, ratingManager: ratingManager)) { // Übergabe des ratingManager
                        MovieCell(movie: movie, favoriteManager: favoriteManager)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct MovieCell: View {
    var movie: Movie
    @ObservedObject var favoriteManager: FavoriteManager
    
    var body: some View {
        VStack {
            if let posterPath = movie.posterPath, !posterPath.isEmpty {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150) // Cover kleiner
                        .cornerRadius(8)
                } placeholder: {
                    Color.gray
                        .frame(width: 100, height: 150) // Cover kleiner
                        .cornerRadius(8)
                }
            } else {
                Color.gray
                    .frame(width: 100, height: 150) // Cover kleiner
                    .cornerRadius(8)
            }
            
            Text(movie.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)
                .padding(.top, 5)
        }
        .padding(.bottom, 10)
    }
}
