import SwiftUI
struct ReviewPopupView: View {
    @Binding var reviewText: String
    var movieTitle: String // Titel des Films
    var dismiss: () -> Void

    var body: some View {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Hintergrund auf Schwarz setzen

                VStack {
                    Text("Bewertung für \(movieTitle)") // Titel des Films anzeigen
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)

                    TextEditor(text: $reviewText)
                        .frame(height: 150)
                        .padding(10)
                        .background(Color(white: 0.85)) // Hellgrauer Hintergrund
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .font(.body)

                    Button(action: {
                        saveReview() // Bewertung speichern
                        dismiss()    // Popup schließen
                    }) {
                        Text("Fertig")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .frame(width: 100)
                    }
                    .padding()
                }
                .padding()
                .background(Color.black)
                .cornerRadius(10)
            }
        }

    func saveReview() {
        UserDefaults.standard.set(reviewText, forKey: "\(movieTitle)_review")
    }
}
