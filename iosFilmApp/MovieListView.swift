import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MoviesViewModel
    var isFutureMovies: Bool

    var body: some View {
        VStack {
            HStack {
                // Dynamische Überschrift basierend auf der Kategorie
                Text(viewModel.isFutureMovies ? "Zukünftige Filme" : "Aktuelle Filme")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Spacer()

                // Vergrößerter Button für den Wechsel zwischen aktuellen und zukünftigen Filmen
                Button(action: {
                    viewModel.toggleMovieCategory() // Toggle-Kategorie
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 30)) // Zahnrad größer machen
                        .foregroundColor(.white)
                }
            }
            .padding()

            ScrollView {
                // 3-Spalten-Raster mit gleichmäßigen Abständen
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ], spacing: 20) {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: DetailView(movie: movie)) {
                            MovieCardView(movie: movie)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black)
        .navigationBarHidden(true)
    }
}
