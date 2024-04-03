//
//  MainDataManager.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/01.
//

import CoreData
import MapKit
import UIKit

final class MainDataManager {
    
    private let coreDataManager = CoreDataManager.shared
    
    func saveContext() throws {
        try coreDataManager.saveContext()
    }
    
    //MARK: - MainCard
    
    func readMainCards() throws -> [MainCardModel] {
        let context = coreDataManager.context
        let request: NSFetchRequest<MainCard> = MainCard.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        guard let mainCards = try? context.fetch(request) else {
            throw CoreDataError.failToReadMainCard
        }
        
        return mainCards.compactMap { mainCard -> MainCardModel? in
            
            guard let id = mainCard.id,
                  let date = mainCard.date else { return nil }
            
            var mainCardModel = MainCardModel(id: id,
                                              title: mainCard.title,
                                              image: nil,
                                              isBookMarked: mainCard.isBookMarked,
                                              date: date,
                                              subCards: [])
            
            if let imageData = mainCard.image {
                mainCardModel.image = UIImage(data: imageData)
            }
            
            
            if let subCardsSet = mainCard.subCards as? Set<SubCard> {
                
                let subCards = readSubCard(who: subCardsSet)
                mainCardModel.subCards = subCards.map { $0! }
            }
            
            return mainCardModel
        }
        
    }
    
    
    func writeMainCard(mainModel: MainCardModel) throws{
        let context = coreDataManager.context
        let entity = MainCard.entity()
        let mainCard = MainCard(entity: entity,
                                insertInto: context)
        
        let request: NSFetchRequest<MainCard> = MainCard.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@",
                                        mainModel.id as CVarArg )
        
        
        let result = try context.fetch(request)
        
        if let mainCardEntityToUpdate = result.first {
            mainCardEntityToUpdate.id = mainModel.id
            mainCardEntityToUpdate.title = mainModel.title
            mainCardEntityToUpdate.isBookMarked = mainModel.isBookMarked
            mainCardEntityToUpdate.date = mainModel.date
            mainCardEntityToUpdate.image = mainModel.image?.pngData()
            
            let subCards = writeSubCard(where: mainCard,
                                        what: mainModel)
            mainCardEntityToUpdate.subCards = NSSet(array: subCards)
            
        } else {
            
            mainCard.id = mainModel.id
            mainCard.title = mainModel.title
            mainCard.isBookMarked = mainModel.isBookMarked
            mainCard.date = mainModel.date
            mainCard.image = mainModel.image?.pngData()
            
            let subCards = writeSubCard(where: mainCard,
                                        what: mainModel)
            
            mainCard.subCards = NSSet(array: subCards)
        }
        
        
    }
    
    func deleteMainCard(id: UUID) throws{
        let context = coreDataManager.context
        
        let request = MainCard.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@",
                                        id as CVarArg)
        let mainCards = try context.fetch(request)
        
        if let mainCard = mainCards.first {
            context.delete(mainCard)
        }
        
        try saveContext()
        
        
    }
    
    //MARK: - SubCard
    
    private func writeSubCard(where mainCard: MainCard,
                              what mainCardModel: MainCardModel) -> [SubCard] {
        let context = coreDataManager.context
        let subCards = mainCardModel.subCards.map { subCardmodel -> SubCard in
            
            let subCardEntity = SubCard.entity()
            let subCard = SubCard(entity: subCardEntity,
                                  insertInto: context)
            
            subCard.title = subCardmodel.title
            subCard.id = subCardmodel.id
            subCard.script = subCardmodel.script
            subCard.starsState = subCardmodel.starsState
            subCard.category = subCardmodel.category?.rawValue
            subCard.mainCard = mainCard
            
            if let price = subCardmodel.price {
                subCard.price = Int64(price)
            }
            
            if let images = subCardmodel.images {
                subCard.imagesData = images.map{ $0.pngData() } as NSObject
            }
            
            subCard.location = writeLocation(subCardModel: subCardmodel)
            
            return subCard
        }
        
        return subCards
    }
    
    private func readSubCard(who subCards: Set<SubCard>) -> [SubCardModel?] {
        
        let subCards = subCards.map { subCard -> SubCardModel? in
            
            guard let id = subCard.id,
                  let starsState = subCard.starsState else { return nil }
            
            var subCardModel = SubCardModel(id: id,
                                            title: subCard.title,
                                            starsState: starsState,
                                            price: Int(subCard.price),
                                            images: [],
                                            script: subCard.script,
                                            location: nil)
            
            if let category = subCard.category {
                subCardModel.category = CardCategory(rawValue: category)
            }
            
            if let imagesData = subCard.imagesData as? [Data] {
                subCardModel.images = imagesData.compactMap { UIImage(data: $0) }
            }
            
            let location = readLocation(who: subCard)
            subCardModel.location = location
            
            return subCardModel
        }
        
        return subCards
    }
    
    //MARK: - Location
    
    private func writeLocation(subCardModel: SubCardModel) -> Location? {
        let context = coreDataManager.context
        
        guard let locationModel = subCardModel.location else { return nil }
        
        let locationEntity = Location.entity()
        let location = Location(entity: locationEntity,
                                insertInto: context)
        
        guard let mapItem = locationModel.mapItem else { return nil }
        
        location.id = locationModel.id
        location.latitude = mapItem.placemark.coordinate.latitude
        location.longitude = mapItem.placemark.coordinate.longitude
        location.title = mapItem.name
        location.categoryName = mapItem.pointOfInterestCategory?.categoryName
        
        return location
    }
    
    private func readLocation(who subCard: SubCard) -> LocationModel {
        var locationModel = LocationModel()
        
        if let location = subCard.location,
           let id = location.id {
            
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                                                    longitude: location.longitude)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = location.title
            
            locationModel = LocationModel(id: id,
                                          mapItem: mapItem)
            
            return locationModel
        }
        
        return locationModel
    }
    
}
