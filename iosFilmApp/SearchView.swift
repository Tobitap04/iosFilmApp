import SwiftUI

struct SearchView: View {
    @StateObject var searchViewModel = SearchViewModel()
    @FocusState private var isTextFieldFocused: Bool // Fokussierung des TextFields

    var body: some View {
        VStack {
            // TextField für die Sucheingabe
            TextField("Nach Filmtitel suchen", text: $searchViewModel.query)
                .focused($isTextFieldFocused) // Fokusstatus binden
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Standard TextField Stil
                .padding()
                .foregroundColor(.black) // Text im Textfeld schwarz
                .background(Color.white) // Hintergrund des Textfeldes auf weiß setzen
                .cornerRadius(10) // Ecken abrunden
                .overlay( // Schwarzer Rand um das TextField
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
                .onChange(of: searchViewModel.query) { newQuery in
                    searchViewModel.searchMovies() // Suchanfrage auslösen, wenn sich der Text ändert
                }
                .tint(.black) // Cursorfarbe auf schwarz setzen
                .accentColor(.gray) // Setzt die Farbe des Clear-Buttons auf grau (etwas heller)

            // Liste der Suchergebnisse
            List(searchViewModel.searchResults, id: \.id) { movie in
                NavigationLink(destination: DetailView(movie: movie)) { // NavigationLink für Klickbarkeit
                    HStack {
                        if let url = movie.fullPosterPath, let posterURL = URL(string: url) {
                            AsyncImage(url: posterURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 75)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                                .foregroundColor(.white) // Titel auf weiß setzen
                            Text(movie.releaseDate ?? "Kein Datum")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 5) // Padding zwischen den Zeilen
                    .background(Color.black) // Hintergrund der Zelle schwarz
                    .cornerRadius(10) // Ecken der Zelle abrunden
                }
                .listRowBackground(Color.black) // Hintergrund der einzelnen Listenzellen schwarz
            }
            .listStyle(PlainListStyle()) // Verhindert die Standard-List-Styles und erlaubt mehr Kontrolle
            .background(Color.black) // Hintergrund der gesamten Liste auf schwarz setzen
            .cornerRadius(10) // Optionale Eckenabrundung für die Liste
        }
        .background(Color.black) // Hintergrund der gesamten View auf schwarz setzen
        .foregroundColor(.white) // Textfarbe auf weiß setzen
    }
}
