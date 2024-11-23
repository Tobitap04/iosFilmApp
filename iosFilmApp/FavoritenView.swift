//
//  FavoritenView 2.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct FavoritenView: View {
    @State private var favoritenFilme = [FilmEntity]()
    
    var body: some View {
        VStack {
            Text("Favoriten")
                .font(.title)
                .foregroundColor(.white)
            
            List(favoritenFilme, id: \.id) { film in
                FilmRow(film: Film(id: Int(film.id), title: film.title ?? "", posterPath: film.posterPath ?? "", releaseDate: film.releaseDate ?? ""))
                    .onTapGesture {
                        // Navigiere zur Detailansicht
                    }
            }
        }
        .background(Color.black)
        .onAppear {
            loadFavoriten()
        }
    }

    func loadFavoriten() {
        favoritenFilme = CoreDataHelper.shared.loadFavoriten()
    }
}