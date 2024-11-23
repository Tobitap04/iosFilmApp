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
    let releaseDate: String
    let overview: String
    let posterPath: String
    let trailerURL: URL?
}