import SwiftUI

struct SearchResultRow: View {
    var movie: Movie
    
    var body: some View {
        HStack {
            Image(systemName: "film.fill")
                .resizable()
                .frame(width: 50, height: 75)
            
            Text(movie.title)
                .foregroundColor(.white)
            
            Spacer()
            
            // Optionalen Wert sicher entpacken und Standardwert verwenden, wenn nil
            Text(movie.releaseDate ?? "Unbekannt")
                .foregroundColor(.gray)
            
            NavigationLink(destination: MovieDetailView(movie: movie)) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
        }
    }
}
