import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .movies
    
    enum Tab {
        case movies, search, favorites
    }
    
    var body: some View {
        VStack {
            // Tab-Buttons
            TabBarView(selectedTab: $selectedTab)
            
            // Content
            Group {
                switch selectedTab {
                case .movies:
                    MovieListView()
                case .search:
                    SearchView()
                case .favorites:
                    FavoritesView()
                }
            }
            .padding(.top, 50)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct TabBarView: View {
    @Binding var selectedTab: ContentView.Tab
    
    var body: some View {
        HStack {
            Button(action: { selectedTab = .movies }) {
                VStack {
                    Image(systemName: "film")
                        .foregroundColor(selectedTab == .movies ? .white : .gray)
                    Text("Filme")
                        .foregroundColor(selectedTab == .movies ? .white : .gray)
                }
            }
            Spacer()
            Button(action: { selectedTab = .search }) {
                VStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(selectedTab == .search ? .white : .gray)
                    Text("Suche")
                        .foregroundColor(selectedTab == .search ? .white : .gray)
                }
            }
            Spacer()
            Button(action: { selectedTab = .favorites }) {
                VStack {
                    Image(systemName: "heart")
                        .foregroundColor(selectedTab == .favorites ? .white : .gray)
                    Text("Favoriten")
                        .foregroundColor(selectedTab == .favorites ? .white : .gray)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}