import SwiftUI

struct ContentView: View {
    @State private var showingUpcoming = false
    @State private var movies: [Movie] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(showingUpcoming ? "Zukünftige Filme" : "Aktuelle Filme")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: toggleMovies) {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(movies) { movie in
                            MovieCell(movie: movie)
                        }
                    }
                }
            }
            .background(Color.black)
            .onAppear {
                fetchMovies()
            }
        }
    }
    
    private func toggleMovies() {
        showingUpcoming.toggle()
        fetchMovies()
    }
    
    private func fetchMovies() {
        let endpoint = showingUpcoming ? "upcoming" : "now_playing"
        MovieService.shared.fetchMovies(endpoint: endpoint) { result in
            switch result {
            case .success(let movies):
                self.movies = movies
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
        }
    }
}

struct MovieCell: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            // Verwenden von AsyncImage für das Laden des Filmcover
            if let posterURL = movie.posterURL {
                AsyncImage(url: posterURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 120, height: 180)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 180)
                            .clipped()
                    case .failure:
                        Image(systemName: "film") // Fallback bei Fehler
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 180)
                            .clipped()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "film")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 180)
                    .clipped()
            }
            Text(movie.title)
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
