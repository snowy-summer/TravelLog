//
//  SubCardsViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/06.
//
import UIKit

final class SubCardsViewModel {
    
    var list: Observable<[SubCardModel]> = Observable([])
    var editingSubCard: Observable<SubCardModel> = Observable(SubCardModel())
    
}

extension SubCardsViewModel {
    
    func selectCard(id: UUID) -> SubCardModel? {
        let index = list.value.firstIndex { subCard in
            subCard.id == id
        }
        guard let index = index else { return nil }
        
        let card = list.value[index]
        
        return card
    }
    
    func updateSubCard(id: UUID,
                       card: SubCardModel ) {
        let index = list.value.firstIndex { subCard in
            subCard.id == id
        }
        guard let index = index else { return }
        
        list.value[index] = card
        
    }
    
    func appendSubCard(title: String?,
                       images: [UIImage]?,
                       starsState: [Bool],
                       price: Int,
                       location: LocationModel?,
                       script: String) {
        
        list.value.append(SubCardModel(title: title,
                                       starsState: starsState,
                                       price: price,
                                       images: images,
                                       script: script,
                                       location: location))
    }
    
    func updateContent(selectedCardId: UUID,
                       title: String?,
                       images: [UIImage]?,
                       starsState: [Bool],
                       price: Int,
                       script: String) {
        
        let index = list.value.firstIndex { subCard in
            subCard.id == selectedCardId
        }
        guard let index = index else { return }
        
        list.value[index] = SubCardModel(title: title,
                                         starsState: starsState,
                                         price: price,
                                         images: images,
                                         script: script,
                                         location:  list.value[index].location)
        
    }
    
    func updateTitle(selectedCardId: UUID,
                     title: String?) {
        
        let index = list.value.firstIndex { subcard in
            subcard.id == selectedCardId
        }
        guard let index = index else { return }
        
        list.value[index].title = title
        
    }
    
    func updateImages(selectedCardId: UUID,
                      images: [UIImage]?) {
        
        let index = list.value.firstIndex { subcard in
            subcard.id == selectedCardId
        }
        guard let index = index else { return }
        
        list.value[index].images = images
        
    }
    
    func updateLocation(selectedCardId: UUID,
                        location: LocationModel) {
        
        let index = list.value.firstIndex { subcard in
            subcard.id == selectedCardId
        }
        guard let index = index else { return }
        
        list.value[index].location = location
        
    }
    
    func appendImage(selectedCardId: UUID,
                     image: UIImage) {
        
        let index = list.value.firstIndex { subCard in
            subCard.id == selectedCardId
        }
        guard let index = index else { return }
        
        list.value[index].images?.append(image)
    }

}

extension SubCardsViewModel {
    
    func updateEditingCardTitle(title: String?) {
        editingSubCard.value.title = title
    }
    
    func updateEditingCardImages(images: [UIImage]?) {
        editingSubCard.value.images = images
    }
    
    func updateEditingCardStarState(starState: [Bool]) {
        editingSubCard.value.starsState = starState
    }
    
    func updateEditingCardPrice(price: String?) {
        
        if let price = price {
            editingSubCard.value.price = (Int(price) != nil) ? Int(price)! : 0
        }
    }
    
    func updateEditingCardLocation(location: LocationModel?) {
        editingSubCard.value.location = location
        
    }
    
    func updateEditingCardScript(text: String?) {
        editingSubCard.value.script = text
    }
    
}
