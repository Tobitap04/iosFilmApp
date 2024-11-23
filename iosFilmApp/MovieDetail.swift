//
//  MovieDetail.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String
    let overview: String
    let voteAverage: Double
    let trailerKey: String?
}