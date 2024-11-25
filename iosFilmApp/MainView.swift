import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .movies

    enum Tab {
        case movies, search, favorites
    }

    var body: some View {
        ZStack {
            // Hintergrundfarbe für alle Ansichten
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Aktuelle Ansicht abhängig vom ausgewählten Tab
                switch selectedTab {
                case .movies:
                    ContentView()
                case .search:
                    SearchView()
                case .favorites:
                    FavoritesView()
                }

                // TabBar am unteren Rand
                HStack(spacing: 0) {
                    TabBarItem(icon: "film.fill", title: "Filme", tab: .movies, selectedTab: $selectedTab)
                    Spacer()
                    TabBarItem(icon: "magnifyingglass", title: "Suche", tab: .search, selectedTab: $selectedTab)
                    Spacer()
                    TabBarItem(icon: "star.fill", title: "Favoriten", tab: .favorites, selectedTab: $selectedTab) // Symbol geändert
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20) // Etwas Abstand für die Icons
                .frame(maxWidth: .infinity) // Hintergrund der Leiste bis zum Rand
                .background(Color.gray.opacity(0.8))
            }
        }
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
