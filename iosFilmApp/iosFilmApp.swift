import SwiftUI

@main
struct iosFilmApp: App {
    @StateObject private var ratingManager = RatingManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
