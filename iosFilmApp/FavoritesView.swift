//
//  FavoritesView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 25.11.24.
//


import SwiftUI

struct FavoritesView: View {
    var body: some View {
        Text("Favoriten")
            .font(.largeTitle)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}