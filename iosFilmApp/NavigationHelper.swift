import SwiftUI

struct NavigationHelper {
    static func navigateToDetail(movie: Movie, from content: some View) -> some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            content
        }
    }
}
