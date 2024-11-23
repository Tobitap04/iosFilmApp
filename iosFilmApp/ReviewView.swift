import SwiftUI

struct ReviewView: View {
    let movie: Movie
    @Binding var currentReview: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Bewertung für \(movie.title)")
                .font(.headline)
                .padding()

            TextEditor(text: $currentReview)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

            Button(action: {
                ReviewManager.shared.saveReview(for: movie, review: currentReview)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Fertig")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}
