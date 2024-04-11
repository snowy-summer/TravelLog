//
//  MainCard+CoreDataProperties.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/29.
//
//

import Foundation
import CoreData


extension MainCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainCard> {
        return NSFetchRequest<MainCard>(entityName: "MainCard")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isBookMarked: Bool
    @NSManaged public var date: Date?
    @NSManaged public var image: Data?
    @NSManaged public var subCards: NSSet?

}

// MARK: Generated accessors for subCards
extension MainCard {

    @objc(addSubCardsObject:)
    @NSManaged public func addToSubCards(_ value: SubCard)

    @objc(removeSubCardsObject:)
    @NSManaged public func removeFromSubCards(_ value: SubCard)

    @objc(addSubCards:)
    @NSManaged public func addToSubCards(_ values: NSSet)

    @objc(removeSubCards:)
    @NSManaged public func removeFromSubCards(_ values: NSSet)

}

extension MainCard : Identifiable {

}
