import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    @State private var isFavorited = false
    @State private var userReview: String = ""
    @State private var showingReviewPopup = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button(action: { showingReviewPopup.toggle() }) {
                        Text("Bewerten")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(height: 300)
                } placeholder: {
                    Color.gray
                        .frame(height: 300)
                }
                
                Text(movie.title)
                    .font(.title)
                    .