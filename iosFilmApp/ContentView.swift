//
//  ContentView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MoviesView()
                .tabItem {
                    Label("Filme", systemImage: "film")
                }
            
            SearchView()
                .tabItem {
                    Label("Suche", systemImage: "magnifyingglass")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }
        }
        .accentColor(.white)
        .background(Color.black)
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        }
    }
}