import SwiftUI

struct MovieCell: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            // Filmcover
            if let posterPath = movie.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)
                } placeholder: {
                    Color.gray
                        .frame(width: 100, height: 150)
                }
            } else {
                Color.gray
                    .frame(width: 100, height: 150)
            }
            
            // Titel und Erscheinungsdatum
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(movie.release_date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
    }
}
