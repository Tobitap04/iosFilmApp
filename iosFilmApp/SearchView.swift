//
//  SearchView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [Movie] = []
    
    var body: some View {
        VStack {
            TextField("Titel, Schauspieler, Regisseur", text: $searchQuery, onCommit: {
                searchMovies(query: searchQuery)
            })
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
            
            List(searchResults) { movie in
                MovieSearchResultCell(movie: movie)
            }
        }
        .background(Color.black)
        .padding()
    }
    
    private func searchMovies(query: String) {
        MovieService.searchMovies(query: query) { result in
            switch result {
            case .success(let movies):
                searchResults = movies
            case .failure:
                break
            }
        }
    }
}

struct MovieSearchResultCell: View {
    var movie: Movie
    
    var body: some View {
        HStack {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 75)
            Text(movie.title)
                .foregroundColor(.white)
            Spacer()
            Text(movie.releaseDate)
                .foregroundColor(.white)
        }
    }
}