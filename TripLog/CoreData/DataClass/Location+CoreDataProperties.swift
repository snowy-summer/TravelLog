//
//  Location+CoreDataProperties.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/29.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var searchCompletionData: Data?
    @NSManaged public var mapItemData: Data?
    @NSManaged public var subCard: SubCard?

}

extension Location : Identifiable {

}
