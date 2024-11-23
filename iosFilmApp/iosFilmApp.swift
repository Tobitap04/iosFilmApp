//
//  iosFilmApp.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

@main
struct iosFilmApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "film")
                        Text("Filme")
                    }
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Suche")
                    }
                
                FavoritesView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("Favoriten")
                    }
            }
            .accentColor(.white)
            .background(Color.black)
        }
    }
}