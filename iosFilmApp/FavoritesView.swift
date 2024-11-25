import SwiftUI

struct FavoritesView: View {
    @StateObject var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack() {
                    // Fixierte Überschrift oben
                    Text("Favoriten")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .center)

                    if favoritesViewModel.favoriteMovies.isEmpty {
                        Text("Keine Favoriten gespeichert")
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        // Liste der Filme
                        List(favoritesViewModel.favoriteMovies, id: \.id) { movie in
                            NavigationLink(destination: DetailView(favoritesViewModel: favoritesViewModel, movie: movie)) {
                                HStack {
                                    // Film-Poster
                                    if let fullPosterPath = movie.fullPosterPath, let url = URL(string: fullPosterPath) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 60, height: 90)
                                            case .success(let image):
                                                image.resizable()
                                                    .scaledToFit()
                                                    .frame(width: 60, height: 90)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            case .failure:
                                                Rectangle()
                                                    .fill(Color.gray)
                                                    .frame(width: 60, height: 90)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(width: 60, height: 90)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }

                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(movie.title)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)

                                        if let releaseDate = movie.releaseDate {
                                            Text(formatDate(releaseDate))
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        } else {
                                            Text("Kein Erscheinungsdatum")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.leading, 10)
                                }
                                .background(Color.black)
                            }
                            .listRowBackground(Color.black)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.black)
                    }
                }
                .onAppear {
                    favoritesViewModel.loadFavoriteMovies()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }

    private func formatDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let parsedDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: parsedDate)
        }
        return date
    }
}
