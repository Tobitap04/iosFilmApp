//
//  CoreDataHelper.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import Foundation
import CoreData
import SwiftUI

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "FilmDataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }

    // Save a film to Core Data
    func saveFilm(id: Int, title: String, posterPath: String, releaseDate: String) {
        let context = persistentContainer.viewContext
        let filmEntity = FilmEntity(context: context)
        filmEntity.id = Int64(id)
        filmEntity.title = title
        filmEntity.posterPath = posterPath
        filmEntity.releaseDate = releaseDate
        
        do {
            try context.save()
        } catch {
            print("Failed to save film: \(error)")
        }
    }

    // Fetch saved films from Core Data
    func loadFavoriten() -> [FilmEntity] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FilmEntity> = FilmEntity.fetchRequest()
        
        do {
            let films = try context.fetch(fetchRequest)
            return films
        } catch {
            print("Failed to fetch films: \(error)")
            return []
        }
    }

    // Delete a film from Core Data
    func deleteFilm(id: Int) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FilmEntity> = FilmEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let films = try context.fetch(fetchRequest)
            if let filmToDelete = films.first {
                context.delete(filmToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete film: \(error)")
        }
    }
}