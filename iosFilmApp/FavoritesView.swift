import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesManager = FavoritesManager()
    
    var body: some View {
        NavigationView {
            VStack {
                // Überschrift
                Text("Favoriten")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                // Liste der Favoriten
                if favoritesManager.favorites.isEmpty {
                    Text("Keine Favoriten hinzugefügt.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                            ForEach(favoritesManager.favorites) { movie in
                                Button(action: {
                                    // Navigation zur Detailansicht
                                }) {
                                    VStack {
                                        // Film-Cover
                                        AsyncImage(url: URL(string: movie.imageUrl)) { image in
                                            image.resizable()
                                                 .scaledToFit()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(height: 150)
                                        
                                        // Film-Titel
                                        Text(movie.title)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
}
