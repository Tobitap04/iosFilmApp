//
//  FavoritesView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoriteMoviesManager = FavoriteMoviesManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Favoriten")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                
                if favoriteMoviesManager.favoriteMovies.isEmpty {
                    Text("Keine gespeicherten Filme.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                            ForEach(favoriteMoviesManager.favoriteMovies) { movie in
                                NavigationHelper.navigateToDetail(
                                    movie: movie,
                                    from: MovieCardView(movie: movie)
                                )
                            }
                        }
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
        }
        .onAppear {
            favoriteMoviesManager.loadFavorites()
        }
    }
}
