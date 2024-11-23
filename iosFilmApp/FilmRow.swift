import SwiftUI

struct FilmRow: View {
    var film: Film

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w92\(film.posterPath)")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 150)

            Text(film.title)
                .foregroundColor(.white)
                .font(.caption)
                .lineLimit(2)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(8)
    }
}
