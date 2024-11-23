import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    var type: MovieListType
    
    var body: some View {
        VStack {
            Text(type == .current ? "Aktuelle Filme" : "Zukünftige Filme")
                .font(.title)
                .foregroundColor(.white)
                .padding()
            
            Button(action: {
                // Wechsel zwischen aktuellen und zukünftigen Filmen
                viewModel.fetchMovies(for: type)
            }) {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.white)
            }
            .padding()
            
            if viewModel.movies.isEmpty {
                Text("Keine Filme gefunden")
                    .foregroundColor(.white)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.movies) { movie in
                            MovieRow(movie: movie)
                        }
                    }
                }
            }
        }
        .background(Color.black)
        .onAppear {
            // Stellen Sie sicher, dass beim ersten Laden der Seite Filme abgerufen werden
            viewModel.fetchMovies(for: type)
        }
    }
}
