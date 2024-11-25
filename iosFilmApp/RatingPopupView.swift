import SwiftUI

struct RatingPopupView: View {
    var movie: Movie
    @Binding var ratingText: String
    var onSave: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Bewertung für \(movie.title)")
                .font(.headline)
                .padding()
            
            TextField("Ihre Bewertung", text: $ratingText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            
            Button(action: {
                onSave(ratingText)
                ratingText = "" // Reset the input field
            }) {
                Text("Bewertung speichern")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}
