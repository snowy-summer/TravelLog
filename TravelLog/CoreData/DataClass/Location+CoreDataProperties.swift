//
//  Location+CoreDataProperties.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/01.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?
    @NSManaged public var categoryName: String?
    @NSManaged public var subCard: SubCard?

}

extension Location : Identifiable {

}
