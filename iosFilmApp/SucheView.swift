//
//  SucheView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct SucheView: View {
    @State private var query = ""
    @State private var searchResults = [Film]()

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Titel, Schauspieler, Regisseur", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.black)
                    .onSubmit {
                        searchFilme()
                    }
            }
            .padding()

            List(searchResults, id: \.id) { film in
                FilmRow(film: film)
                    .onTapGesture {
                        // Navigiere zur Detailansicht
                    }
            }
        }
        .background(Color.black)
    }

    func searchFilme() {
        let apiKey = "453aa8a21df8d125bd9356fcd2a8e417"
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)")!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            if let filmeResponse = try? decoder.decode(FilmeResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.searchResults = filmeResponse.results
                }
            }
        }.resume()
    }
}
