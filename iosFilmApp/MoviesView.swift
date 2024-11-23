import SwiftUI

struct MoviesView: View {
    @ObservedObject var viewModel = MoviesViewModel()

    var body: some View {
        VStack {
            Text("Aktuelle Filme")
                .font(.headline)
                .padding()

            // Aktuelle Filme anzeigen
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.currentMovies) { movie in
                        MovieCell(movie: movie) // Zeigt das Filmzellen-Design
                    }
                }
            }
            .onAppear {
                viewModel.loadCurrentMovies() // Filme laden, wenn die Ansicht erscheint
            }

            Divider()

            Text("Zukünftige Filme")
                .font(.headline)
                .padding()

            // Zukünftige Filme anzeigen
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.upcomingMovies) { movie in
                        MovieCell(movie: movie) // Zeigt das Filmzellen-Design
                    }
                }
            }
            .onAppear {
                viewModel.loadUpcomingMovies() // Filme laden, wenn die Ansicht erscheint
            }
        }
        .background(Color.black) // Hintergrundfarbe der Ansicht
        .foregroundColor(.white) // Textfarbe
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
