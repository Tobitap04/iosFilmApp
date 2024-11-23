import SwiftUI

struct MovieCell: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            Image(systemName: "photo") // Placeholder for poster image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 150)
            Text(movie.title)
                .foregroundColor(.white)
                .lineLimit(2)
                .frame(width: 100, alignment: .center)
        }
        .background(Color.gray)
        .cornerRadius(8)
    }
}
