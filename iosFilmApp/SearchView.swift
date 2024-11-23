import SwiftUI

struct SearchView: View {
    @State private var searchText = "" // Text, der im Suchfeld eingegeben wird
    @ObservedObject private var viewModel = SearchViewModel() // Instanziierung des ViewModels
    
    var body: some View {
        NavigationView {
            VStack {
                // Suchfeld
                TextField("Suche nach Titel, Schauspieler, Regisseur", text: $searchText, onCommit: searchMovies)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding()

                // Liste der Suchergebnisse
                List(viewModel.searchResults) { movie in
                    HStack {
                        // Platzhalter für das Filmcover
                        if let posterPath = movie.poster_path {
                            // Sicherstellen, dass die URL korrekt ist
                            if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                                AsyncImage(url: posterURL, content: { phase in
                                    switch phase {
                                    case .empty:
                                        // Ladeindikator
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .frame(width: 50, height: 75)
                                    case .success(let image):
                                        // Bild erfolgreich geladen
                                        image.resizable()
                                             .scaledToFit()
                                             .frame(width: 50, height: 75)
                                    case .failure:
                                        // Fehler - Platzhalterbild
                                        Image(systemName: "film.fill")
                                             .resizable()
                                             .scaledToFit()
                                             .frame(width: 50, height: 75)
                                    @unknown default:
                                        // Für zukünftige Erweiterungen
                                        Image(systemName: "film.fill")
                                             .resizable()
                                             .scaledToFit()
                                             .frame(width: 50, height: 75)
                                    }
                                })
                            } else {
                                // Wenn die URL ungültig ist, ein Platzhalter anzeigen
                                Image(systemName: "film.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 75)
                            }
                        } else {
                            // Wenn kein Poster vorhanden ist, ein Platzhalter anzeigen
                            Image(systemName: "film.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 75)
                        }
                        
                        VStack(alignment: .leading) {
                            // Titel des Films
                            Text(movie.title)
                                .font(.headline)
                            // Erscheinungsdatum des Films
                            Text(movie.release_date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // Pfeil nach rechts für die Navigation
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .background(
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            EmptyView()
                        }
                        .opacity(0) // Macht die NavigationLink unsichtbar, aber funktional
                    )
                }
            }
            .onAppear {
                // Wenn die View erscheint, wird die Funktion zum Initialisieren von Suchergebnissen aufgerufen
                if !searchText.isEmpty {
                    viewModel.searchMovies(query: searchText)
                }
            }
            .navigationTitle("Suche") // Titel für die Navigation
        }
    }

    private func searchMovies() {
        // Die Methode zum Starten der Suche nach Filmen aufrufen
        viewModel.searchMovies(query: searchText)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
