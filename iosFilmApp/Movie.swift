//
//  Movie.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let posterPath: String
    let trailerURL: URL?

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.releaseDate == rhs.releaseDate &&
               lhs.overview == rhs.overview &&
               lhs.posterPath == rhs.posterPath &&
               lhs.trailerURL == rhs.trailerURL
    }
}
