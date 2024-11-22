import CoreData
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "MovieApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data loading error: \(error)")
            }
        }
    }
    
    func saveFavorite(movie: Movie) {
        let context = persistentContainer.viewContext
        let favorite = MovieEntity(context: context)
        favorite.id = Int64(movie.id)
        favorite.title = movie.title
        favorite.posterPath = movie.posterPath ?? ""
        
        do {
            try context.save()
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }

    func fetchFavorites() -> [Movie] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                Movie(
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    overview: "",  // Kann leer bleiben, da nicht gespeichert
                    releaseDate: "",
                    posterPath: entity.posterPath
                )
            }
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }
    
    func saveComment(for movieID: Int, comment: String) {
        let context = persistentContainer.viewContext
        let commentEntity = CommentEntity(context: context)
        commentEntity.id = Int64(movieID)
        commentEntity.comment = comment
        
        do {
            try context.save()
        } catch {
            print("Failed to save comment: \(error)")
        }
    }

    func fetchComments(for movieID: Int) -> [String] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<CommentEntity> = CommentEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieID)
        
        do {
            let entities = try context.fetch(request)
            return entities.map { $0.comment ?? "" }
        } catch {
            print("Failed to fetch comments: \(error)")
            return []
        }
    }


}
