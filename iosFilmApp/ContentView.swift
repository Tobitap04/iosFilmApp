import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .movies
    
    enum Tab {
        case movies, search, favorites
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    switch selectedTab {
                    case .movies:
                        MovieListView(viewModel: MovieListViewModel(), type: .current)
                    case .search:
                        SearchView()
                    case .favorites:
                        FavoritesView()
                    }
                }
                Spacer()
                
                // Bottom Tab Bar
                HStack {
                    Spacer()
                    Button(action: { selectedTab = .movies }) {
                        VStack {
                            Image(systemName: "film.fill")
                                .foregroundColor(selectedTab == .movies ? .white : .gray)
                            Text("Filme")
                                .font(.footnote)
                                .foregroundColor(selectedTab == .movies ? .white : .gray)
                        }
                    }
                    Spacer()
                    Button(action: { selectedTab = .search }) {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(selectedTab == .search ? .white : .gray)
                            Text("Suche")
                                .font(.footnote)
                                .foregroundColor(selectedTab == .search ? .white : .gray)
                        }
                    }
                    Spacer()
                    Button(action: { selectedTab = .favorites }) {
                        VStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(selectedTab == .favorites ? .white : .gray)
                            Text("Favoriten")
                                .font(.footnote)
                                .foregroundColor(selectedTab == .favorites ? .white : .gray)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.5))
                .cornerRadius(16)
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
    }
}
