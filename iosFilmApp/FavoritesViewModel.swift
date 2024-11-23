//
//  FavoritesViewModel.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteMovies = [Movie]()
    
    // Hier kannst du Logik hinzufügen, um Filme in Favoriten zu speichern
    func addToFavorites(movie: Movie) {
        favoriteMovies.append(movie)
    }
    
    func removeFromFavorites(movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
    }
}