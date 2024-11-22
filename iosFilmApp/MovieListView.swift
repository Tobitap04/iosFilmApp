import SwiftUI

struct MovieListView: View {
    var films: [Film]
    var onMovieTapped: (Film) -> Void

    // Defining the grid layout for 3 columns
    let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 20) {  // Added spacing between cells
                ForEach(films) { film in
                    VStack {
                        // Image of the film, scaled to fit with aspect ratio
                        if let posterURL = film.posterURL {
                            AsyncImage(url: posterURL) { image in
                                image.resizable()
                                     .scaledToFit()
                                     .frame(height: 150)  // Fixed height for images
                            } placeholder: {
                                Color.gray.frame(height: 150)  // Placeholder if image is loading
                            }
                        }

                        Text(film.title)
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(1)  // Avoids text overflow
                    }
                    .padding(5)
                    .background(Color.black)
                    .cornerRadius(10)  // Makes the cell corners rounded
                    .onTapGesture {
                        onMovieTapped(film)  // Navigates to the film detail view
                    }
                }
            }
            .padding()
        }
    }
}
