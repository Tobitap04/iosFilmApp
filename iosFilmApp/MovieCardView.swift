//
//  MovieCardView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: movie.posterPath)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10) // Abgerundete Ecken
            } placeholder: {
                ProgressView()
            }
            .frame(height: 150)
            
            Text(movie.title)
                .foregroundColor(.white)
                .font(.caption)
                .lineLimit(1)
        }
    }
}
