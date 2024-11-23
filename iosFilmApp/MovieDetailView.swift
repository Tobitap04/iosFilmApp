import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.toggleFavoriteStatus()
                }) {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    // Bewerten Logik
                }) {
                    Text("Bewerten")
                        .foregroundColor(.white)
                        .padding()
                }
            }
            
            ScrollView {
                VStack {
                    Image(systemName: "photo") // Placeholder für das Film-Cover
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                    
                    Text(viewModel.movie.title)
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Erscheinungsdatum: \(viewModel.movie.release_date)")   // Hier den neuen release_date verwenden
                        .foregroundColor(.white)
                    
                    Text(viewModel.movie.overview)  // Hier das overview-Feld verwenden
                        .foregroundColor(.white)
                        .padding()
                    
                    if let trailerURL = viewModel.movie.trailerURL {
                        Link("Trailer ansehen", destination: URL(string: trailerURL)!)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
            
            // Bewertungs-Pop-up
            if !viewModel.reviewText.isEmpty {
                VStack {
                    TextField("Deine Bewertung", text: $viewModel.reviewText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Fertig") {
                        viewModel.saveReview()
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
            }
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
    }
}
