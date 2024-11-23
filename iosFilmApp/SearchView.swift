//
//  SearchView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var searchQuery = ""
    
    var body: some View {
        VStack {
            TextField("Titel, Schauspieler, Regisseur", text: $searchQuery)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
                .foregroundColor(.black)
                .onChange(of: searchQuery) { newValue in
                    searchViewModel.searchMovies(query: newValue)
                }
            
            ScrollView {
                ForEach(searchViewModel.searchResults) { movie in
                    SearchResultCell(movie: movie)
                }
            }
        }
        .padding()
    }
}

struct SearchResultCell: View {
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
            
            Text(movie.releaseDate)
                .foregroundColor(.white)
                .font(.subheadline)
        }
    }
}