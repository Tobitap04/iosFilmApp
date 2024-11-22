import SwiftUI

struct FilmsViewController: View {
    @State private var films: [Film] = []
    @State private var currentTab: String = "now_playing"  // "now_playing" or "upcoming"

    var tabIndex: Int

    var body: some View {
        VStack {
            HStack {
                Text(currentTab == "now_playing" ? "Aktuelle Filme" : "Zukünftige Filme")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                Spacer()

                Button(action: {
                    currentTab = currentTab == "now_playing" ? "upcoming" : "now_playing"
                    loadMovies()
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.white)
                }
                .padding()
            }

            MovieListView(films: films) { film in
                // Navigate to detail view
            }
            .onAppear {
                loadMovies()
            }
        }
        .background(Color.black)
    }

    func loadMovies() {
        TMDBService().fetchMovies(type: currentTab) { films in
            if let films = films {
                self.films = films
            }
        }
    }
}
