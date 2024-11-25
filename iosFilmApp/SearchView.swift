import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [Movie] = []

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)

                        TextField(
                            "Titel, Schauspieler, Regisseur",
                            text: $searchQuery
                        )
                        .foregroundColor(.white) // Eingabetextfarbe
                        .placeholder(when: searchQuery.isEmpty) { // Custom Placeholder Modifier
                            Text("Titel, Schauspieler, Regisseur")
                                .foregroundColor(.gray) // Hellgrau für bessere Sichtbarkeit
                        }
                        .onChange(of: searchQuery) { _ in
                            performSearch() // Automatische Suche bei Texteingabe
                        }
                        .padding(.vertical, 10)
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding()
                }

                ScrollView {
                    ForEach(searchResults) { movie in
                        NavigationHelper.navigateToDetail(
                            movie: movie,
                            from: HStack {
                                AsyncImage(url: URL(string: movie.posterPath)) { image in
                                    image.resizable()
                                        .frame(width: 50, height: 75)
                                        .cornerRadius(8) // Abrundung der Ecken
                                } placeholder: {
                                    ProgressView()
                                }

                                VStack(alignment: .leading) { // Links ausgerichtet
                                    Text(movie.title)
                                        .foregroundColor(.white)
                                        .bold()
                                        .multilineTextAlignment(.leading) // Links ausgerichtet
                                    Text(formatDate(movie.releaseDate)) // Datum im deutschen Format
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        )
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    private func performSearch() {
        TMDBService.searchAll(query: searchQuery) { results in
            searchResults = results
        }
    }

    private func formatDate(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dateObj = formatter.date(from: date) {
            formatter.locale = Locale(identifier: "de_DE")
            formatter.dateStyle = .long
            return formatter.string(from: dateObj)
        }
        return date
    }
}

// Custom Placeholder Modifier
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}
