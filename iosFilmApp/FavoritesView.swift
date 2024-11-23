//
//  FavoritesView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct FavoritesView: View {
    var body: some View {
        List(MovieService.getFavoriteMovies()) { movie in
            NavigationLink(destination: MovieDetailView(movie: movie)) {
                MovieCell(movie: movie)
            }
        }
        .background(Color.black)
        .navigationTitle("Favoriten")
    }
}