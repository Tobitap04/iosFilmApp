import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [Movie] = []
    @ObservedObject var movieAPI = MovieAPI() // Ein Objekt zur Abfrage der Filmdatenbank

    var body: some View {
        NavigationView {  // Sicherstellen, dass NavigationView hier um die gesamte View ist
            VStack(alignment: .leading) {
                // Überschrift
                Text("Suche")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top, 20)  // Etwas Abstand oben hinzufügen

                // Suchleiste
                HStack {
                    Image(systemName: "magnifyingglass") // Lupe im Textfeld
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    
                    TextField("Titel, Schauspieler, Regisseur", text: $searchText)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        .onChange(of: searchText) { newValue in
                            performSearch(query: newValue)
                        }
                }
                .padding(.horizontal)
                .background(Color.black.opacity(0.8))  // Hintergrund der Suchleiste
                .cornerRadius(8)
                .padding(.top, 10) // Etwas Abstand nach oben

                // Suchergebnisse
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(searchResults, id: \.id) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie, ratingManager: RatingManager())) {
                                HStack {
                                    // Filmcover
                                    if let posterPath = movie.posterPath {
                                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w92/\(posterPath)")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 75)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 50, height: 75)
                                                .cornerRadius(8)
                                        }
                                    } else {
                                        Color.gray
                                            .frame(width: 50, height: 75)
                                            .cornerRadius(8)
                                    }

                                    // Filminformationen
                                    VStack(alignment: .leading) {
                                        Text(movie.title)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading) // Titel linksbündig
                                        
                                        // Umwandlung des Datums ins deutsche Format
                                        if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                                            let formattedDate = formatDate(releaseDate)
                                            Text(formattedDate)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()

                                    // Pfeil nach rechts
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            }
                            .background(Color.black.opacity(0.8)) // Hintergrund für anklickbare Reihe
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color.black.edgesIgnoringSafeArea(.all)) // Ganzflächiger schwarzer Hintergrund
            }
            .navigationBarHidden(true) // Die Navigationsleiste wird verborgen
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Hintergrund auf ganz schwarz setzen
        }
    }

    // Funktion zur Durchführung der Suche
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        // API-Aufruf mit Titel, Schauspieler oder Regisseur
        movieAPI.searchMovies(query: query) { movies in
            DispatchQueue.main.async {
                self.searchResults = movies
            }
        }
    }

    // Funktion zur Formatierung des Datums ins deutsche Format
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium // Formatierung auf "dd. MMM yyyy"
            formatter.locale = Locale(identifier: "de_DE")
            return formatter.string(from: date)
        }
        return dateString // Rückgabe des Originaldatums, wenn die Formatierung fehlschlägt
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
