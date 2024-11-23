import SwiftUI

struct MovieRow: View {
    var movie: Movie
    
    var body: some View {
        VStack {
            AsyncImage(url: movie.imageUrl) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 225)
                    .cornerRadius(8)
            } placeholder: {
                Color.gray.frame(width: 150, height: 225)
            }
            Text(movie.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)
                .padding([.top, .horizontal])
        }
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .padding(5)
    }
}
