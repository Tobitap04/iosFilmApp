import SwiftUI

@main
struct iosFilmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MovieListView()
        }
    }
}
