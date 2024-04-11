//
//  SubCard+CoreDataProperties.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/02.
//
//

import Foundation
import CoreData
import UIKit


extension SubCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubCard> {
        return NSFetchRequest<SubCard>(entityName: "SubCard")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imagesData: NSObject?
    @NSManaged public var price: Double
    @NSManaged public var script: String?
    @NSManaged public var starsState: [Bool]?
    @NSManaged public var title: String?
    @NSManaged public var category: String?
    @NSManaged public var location: Location?
    @NSManaged public var mainCard: MainCard?

}

extension SubCard : Identifiable {

}
