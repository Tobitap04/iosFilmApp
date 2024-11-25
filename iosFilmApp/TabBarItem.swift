//
//  TabBarItem.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 25.11.24.
//


import SwiftUI

struct TabBarItem: View {
    let icon: String
    let title: String
    let tab: MainView.Tab
    @Binding var selectedTab: MainView.Tab

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(selectedTab == tab ? .white : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(selectedTab == tab ? .white : .gray)
        }
        .onTapGesture {
            selectedTab = tab
        }
        .frame(maxWidth: .infinity) // Jeder TabItem nimmt gleichen Platz ein
    }
}
