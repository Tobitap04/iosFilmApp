import UIKit
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Statische Eigenschaft für den PersistentContainer
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourAppName") // Ersetze 'YourAppName' durch den Namen deines Core Data Modells
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Getter für den Managed Object Context
    var context: NSManagedObjectContext {
        return AppDelegate.persistentContainer.viewContext
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Hier können weitere Initialisierungen vorgenommen werden
        return true
    }

    // Speichern von Änderungen im Core Data
    func saveContext() {
        let context = AppDelegate.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
