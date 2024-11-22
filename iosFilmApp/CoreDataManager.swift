import Foundation
import CoreData
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var persistentContainer: NSPersistentContainer!
    
    func setupCoreDataStack() {
        persistentContainer = NSPersistentContainer(name: "MovieDataModel")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading persistent store: \(error)")
            }
        }
    }
    
    func saveComment(movieId: Int, comment: String) {
        let context = persistentContainer.viewContext
        let commentEntity = CommentEntity(context: context)
        commentEntity.movieId = Int32(movieId)
        commentEntity.text = comment
        
        do {
            try context.save()
        } catch {
            print("Error saving comment: \(error)")
        }
    }
    
    func fetchComments(forMovie movieId: Int) -> [String] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CommentEntity> = CommentEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieId == %d", movieId)
        
        do {
            let comments = try context.fetch(fetchRequest)
            return comments.map { $0.text ?? "" }
        } catch {
            print("Error fetching comments: \(error)")
            return []
        }
    }
}
