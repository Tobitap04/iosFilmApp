import SwiftUI

struct FilmeView: View {
    @State private var aktuelleFilme = [Film]()
    @State private var zukunftsFilme = [Film]()
    @State private var isAktuelleFilme = true
    @State private var errorMessage: String? = nil
    private let apiKey = "453aa8a21df8d125bd9356fcd2a8e417" // Ersetze dies mit deinem echten API-Schlüssel

    var body: some View {
        VStack {
            // Überschrift und Button für Filmwechsel
            HStack {
                Text(isAktuelleFilme ? "Aktuelle Filme" : "Zukünftige Filme")
                    .font(.title)
                    .foregroundColor(.white)

                Spacer()

                Button(action: {
                    toggleFilmView()
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.white)
                }
            }

            // Fehleranzeige
            if let errorMessage = errorMessage {
                Text("Fehler: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }

            // ScrollView mit Filmen
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(isAktuelleFilme ? aktuelleFilme : zukunftsFilme) { film in
                        FilmRow(film: film)
                            .onTapGesture {
                                // Navigiere zur Detailansicht
                            }
                    }
                }
            }
        }
        .background(Color.black)
        .onAppear {
            loadFilme()
        }
    }

    // Wechsel zwischen aktuellen und zukünftigen Filmen
    func toggleFilmView() {
        isAktuelleFilme.toggle()
        loadFilme()
    }

    // API-Aufruf zur Lade der Filme
    func loadFilme() {
        // URL-String abhängig von der Ansicht
        let urlString = isAktuelleFilme ?
            "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)" :
            "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }

        // Daten abfragen
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Netzwerkfehler: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Datenfehler: Keine Daten erhalten."
                }
                return
            }

            // JSON-Decoding der Antwort
            let decoder = JSONDecoder()
            
            do {
                let filmeResponse = try decoder.decode(FilmeResponse.self, from: data)
                DispatchQueue.main.async {
                    if self.isAktuelleFilme {
                        self.aktuelleFilme = filmeResponse.results
                    } else {
                        self.zukunftsFilme = filmeResponse.results
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Fehler beim Verarbeiten der Daten: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
