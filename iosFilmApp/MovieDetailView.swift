//
//  MovieDetailView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct MovieDetailView: View {
    var movie: MovieDetail
    
    var body: some View {
        VStack {
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 300)
            
            Text(movie.title)
                .font(.title)
                .foregroundColor(.white)
            
            Text("Release: \(movie.releaseDate)")
                .foregroundColor(.white)
            
            Text(movie.overview)
                .foregroundColor(.white)
                .padding()
            
            Button(action: {
                // Füge zu Favoriten hinzu
            }) {
                Text("Zu Favoriten hinzufügen")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .background(Color.black)
        .padding()
    }
}