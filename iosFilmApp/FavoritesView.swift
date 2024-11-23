//
//  FavoritesView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(favoritesViewModel.favoriteMovies) { movie in
                FavoriteCell(movie: movie)
            }
        }
        .onAppear {
            // Favoriten laden, wenn erforderlich
        }
    }
}

struct FavoriteCell: View {
    var movie: Movie
    
    var body: some View {
        VStack {
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 150)
            
            Text(movie.title)
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}