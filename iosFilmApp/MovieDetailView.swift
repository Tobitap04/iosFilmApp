import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State private var comment: String = ""
    @State private var isFavorite: Bool = false
    private let coreDataManager = CoreDataManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(movie.title)
                .font(.largeTitle)
                .bold()
            
            if let url = movie.posterURL {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
            }
            
            HStack {
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                TextField("Add a comment...", text: $comment, onCommit: saveComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding()
        .onAppear {
            checkIfFavorite()
        }
    }
    
    private func toggleFavorite() {
        if isFavorite {
            // Logik zum Entfernen (optional)
        } else {
            coreDataManager.saveFavorite(movie: movie)
            isFavorite = true
        }
    }
    
    private func saveComment() {
        coreDataManager.saveComment(for: movie.id, comment: comment)
        comment = "" // Textfeld zurücksetzen
    }
    
    private func checkIfFavorite() {
        let favorites = coreDataManager.fetchFavorites()
        isFavorite = favorites.contains { $0.id == movie.id }
    }
}
