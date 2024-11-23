//
//  MoviesView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct MoviesView: View {
    @State private var showingUpcomingMovies = false
    @State private var movies: [Movie] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(showingUpcomingMovies ? "Zukünftige Filme" : "Aktuelle Filme")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: toggleMovieCategory) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                        ForEach(movies) { movie in
                            NavigationHelper.navigateToDetail(
                                movie: movie,
                                from: MovieCardView(movie: movie)
                            )
                        }
                    }
                }
                .onAppear {
                    loadMovies()
                }
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
    
    private func toggleMovieCategory() {
        showingUpcomingMovies.toggle()
        loadMovies()
    }
    
    private func loadMovies() {
        let category = showingUpcomingMovies ? TMDBCategory.upcoming : TMDBCategory.nowPlaying
        TMDBService.fetchMovies(category: category) { fetchedMovies in
            movies = fetchedMovies
        }
    }
}
