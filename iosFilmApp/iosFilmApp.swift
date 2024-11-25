import SwiftUI

@main
struct iosFilmApp: App {
    var body: some Scene {
        WindowGroup {
            MoviesViewControllerRepresentable() // Verwenden des Representable Wrappers
        }
    }
}

// Wrapper für den MoviesViewController, um ihn in SwiftUI zu integrieren
struct MoviesViewControllerRepresentable: View {
    var body: some View {
        // Die UIViewControllerRepresentable-Konformität ermöglicht es, UIKit-ViewController in SwiftUI zu verwenden
        MoviesViewControllerWrapper()
            .edgesIgnoringSafeArea(.all)
    }
}

struct MoviesViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MoviesViewController {
        return MoviesViewController()
    }
    
    func updateUIViewController(_ uiViewController: MoviesViewController, context: Context) {
        // Hier kannst du die Aktualisierung der ViewController-Daten vornehmen
    }
}
