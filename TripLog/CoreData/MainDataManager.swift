//
//  MainDataManager.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/01.
//

import CoreData
import UIKit

final class MainDataManager {
    
    private let coreDataManager = CoreDataManager.shared
    
    func readAllMainCards() throws -> [MainCardModel] {
        let context = coreDataManager.context
        let request: NSFetchRequest<MainCard> = MainCard.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            let mainCards = try context.fetch(request)
            
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
            
            
        } catch {
            throw error
        }
    }
    
    
    func writeMainCard(mainModel: MainCardModel) {
        let context = coreDataManager.context
        let entity = MainCard.entity()
        let mainCard = MainCard(entity: entity,
                                insertInto: context)
        
        let request: NSFetchRequest<MainCard> = MainCard.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@",
                                        mainModel.id as CVarArg )
        
        do {
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
            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func deleteMainCard(id: UUID) {
        let context = coreDataManager.context
        
        let request = MainCard.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@",
                                        id as CVarArg)
        do {
            let mainCards = try context.fetch(request)
            
            if let mainCard = mainCards.first {
                context.delete(mainCard)
            }
            
            saveContext()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func saveContext() {
        coreDataManager.saveContext()
    }
    
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
            subCard.mainCard = mainCard
            
            if let price = subCardmodel.price {
                subCard.price = Int32(price)
            }
            
            if let images = subCardmodel.images {
                subCard.imagesData = images.map{ $0.pngData() } as NSObject
            }
            
            if let locationModel = subCardmodel.location {
                
                let locationEntity = Location.entity()
                let location = Location(entity: locationEntity,
                                        insertInto: context)
                
                location.id = locationModel.id
                
                subCard.location = location
            }
            
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
            
            if let imagesData = subCard.imagesData as? [Data] {
                subCardModel.images = imagesData.compactMap { UIImage(data: $0) }
            }
            
            if let location = subCard.location,
               let id = location.id {
                
                let locationModel = LocationModel(id: id)
                subCardModel.location = locationModel
            }
            
            return subCardModel
        }
        
        return subCards
    }
}
