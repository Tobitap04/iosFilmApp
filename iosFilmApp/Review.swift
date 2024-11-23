//
//  Review.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import Foundation

struct Review: Codable, Identifiable {
    let id = UUID()
    let movieID: Int
    var content: String
}