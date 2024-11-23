//
//  ReviewModal.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI

struct ReviewModal: View {
    @Binding var reviewText: String
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Bewertung abgeben")
                .font(.title)

            TextEditor(text: $reviewText)
                .border(Color.gray)
                .frame(height: 100)

            Button("Fertig") {
                isPresented = false
                // Bewertung speichern
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}