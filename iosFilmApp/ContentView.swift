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
            FilmeView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Filme")
                }
            
            SucheView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Suche")
                }
            
            FavoritenView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favoriten")
                }
        }
        .accentColor(.white) // Aktuelle Ansicht wird weiß hervorgehoben
        .background(Color.black) // Hintergrundfarbe schwarz
    }
}