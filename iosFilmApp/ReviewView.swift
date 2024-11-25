//
//  ReviewView.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import SwiftUI


struct ReviewView: View {
    @Binding var review: String
    let movieID: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Bewertung schreiben")
                .font(.headline)
                .padding()
            
            TextEditor(text: $review)
                .padding()
                .background(Color(white: 0.9))
                .cornerRadius(8)
                .padding()
            
            Button("Fertig") {
                saveReview()
                dismiss()
            }
            .foregroundColor(.blue)
            .padding()
        }
    }
    
    private func saveReview() {
        UserDefaults.standard.set(review, forKey: "\(movieID)-review")
    }
}
