//
//  Movie.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 25.11.24.
//


import Foundation

struct Movie: Decodable {
    let title: String
    let posterPath: String?
    let releaseDate: String?  // Optional, falls der Release-Date fehlt
    let overview: String
    let id: Int
}
