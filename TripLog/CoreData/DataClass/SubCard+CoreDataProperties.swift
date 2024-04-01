//
//  SubCard+CoreDataProperties.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/29.
//
//

import Foundation
import CoreData


extension SubCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubCard> {
        return NSFetchRequest<SubCard>(entityName: "SubCard")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var script: String?
    @NSManaged public var starsState: [Bool]?
    @NSManaged public var imagesData: NSObject?
    @NSManaged public var price: Int32
    @NSManaged public var mainCard: MainCard?
    @NSManaged public var location: Location?

}

extension SubCard : Identifiable {

}
