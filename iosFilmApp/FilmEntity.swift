//
//  FilmEntity.swift
//  iosFilmApp
//
//  Created by Tobias Tappe on 23.11.24.
//


import Foundation
import CoreData

@objc(FilmEntity)
public class FilmEntity: NSManagedObject {
}

extension FilmEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmEntity> {
        return NSFetchRequest<FilmEntity>(entityName: "FilmEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
}