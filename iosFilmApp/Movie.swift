//
//  Movie.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let releaseDate: String  // Or use 'Date' if you want to parse it
    let posterPath: String
    let overview: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, releaseDate, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
