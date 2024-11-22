import SwiftUI

struct SearchViewController: View {
    @State private var searchText = ""
    @State private var searchResults: [Film] = []

    var tabIndex: Int

    var body: some View {
        VStack {
            TextField("Titel, Schauspieler, Regisseur", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .foregroundColor(.white)
                .background(Color.gray.opacity(0.5))

            List(searchResults) { film in
                HStack {
                    if let posterURL = film.posterURL {
                        AsyncImage(url: posterURL)
                            .scaledToFit()
                            .frame(width: 50, height: 75)
                    }
                    Text(film.title)
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        // Navigate to film details
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                }
                .onTapGesture {
                    // Navigate to film detail
                }
            }
            .onChange(of: searchText) { _ in
                TMDBService().searchMovies(query: searchText) { films in
                    if let films = films {
                        self.searchResults = films
                    }
                }
            }
        }
        .background(Color.black)
    }
}
