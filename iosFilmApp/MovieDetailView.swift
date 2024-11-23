import SwiftUI

struct MovieDetailView: View {
    @State var movie: Movie
    @State private var userReview = ""
    @State private var trailerKey: String?
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: toggleFavorite) {
                        Image(systemName: movie.isFavorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.title)
                    }
                    Spacer()
                    Button(action: rateMovie) {
                        Text("Bewerten")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
                .padding()
                
                AsyncImage(url: movie.posterURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 300, height: 450)
                .cornerRadius(10)
                
                Text(movie.title)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                Text("Erscheinungsdatum: \(movie.releaseDate)")
                    .foregroundColor(.white)
                    .padding([.leading, .trailing])
                
                Text(movie.overview)
                    .foregroundColor(.white)
                    .padding()
                
                if let trailerKey = trailerKey {
                    YouTubePlayerView(trailerKey: trailerKey)
                        .frame(height: 200)
                        .padding()
                }
                
                VStack(alignment: .leading) {
                    Text("Bewertung:")
                        .font(.headline)
                        .foregroundColor(.white)
                    TextEditor(text: $userReview)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: saveReview) {
                    Text("Fertig")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: goBack) {
                    Text("Zurück")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
        }
        .background(Color.black)
        .onAppear {
            loadTrailer()
        }
    }
    
    private func toggleFavorite() {
        if movie.isFavorite {
            MovieService.removeFavoriteMovie(movie: movie)
            movie.isFavorite = false
        } else {
            MovieService.addFavoriteMovie(movie: movie)
            movie.isFavorite = true
        }
    }
    
    private func rateMovie() {
        // Rating-Logik für Bewertung
    }
    
    private func saveReview() {
        MovieService.rateMovie(movie: movie, review: userReview)
    }
    
    private func loadTrailer() {
        // Entferne die optionale Bindung, da `movie.id` kein optionaler Wert ist
        let movieId = movie.id
        MovieService.getTrailerKey(forMovie: movieId) { result in
            switch result {
            case .success(let key):
                trailerKey = key
            case .failure:
                break
            }
        }
    }
    
    private func goBack() {
        // Logik für Zurücknavigation
    }
}

struct YouTubePlayerView: View {
    var trailerKey: String
    
    var body: some View {
        WebView(url: URL(string: "https://www.youtube.com/embed/\(trailerKey)")!)
            .cornerRadius(10)
    }
}
