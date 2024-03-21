//
//  SubCardsViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/06.
//
import UIKit

final class SubCardsViewModel {
    
    var list: Observable<[SubCardModel]> = Observable([])
    
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
    
    func appendSubCard(title: String?,
                       images: [UIImage]?,
                       starsState: [Bool],
                       price: Int,
                       location: LocationModel?,
                       script: String) {
        
        list.value.append(SubCardModel(title: title,
                                       starsState: starsState,
                                       money: price,
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
                                         money: price,
                                         images: images,
                                         script: script,
                                         location:  list.value[index].location)
        
    }
    
    func appendImage(selectedCardId: UUID,
                     image: UIImage) {
        
        let index = list.value.firstIndex { subCard in
            subCard.id == selectedCardId
        }
        guard let index = index else { return }
        
        list.value[index].images?.append(image)
    }
    
    func clearImages(selectedCardId: UUID) {
        
        let index = list.value.firstIndex { subCard in
            subCard.id == selectedCardId
        }
        guard let index = index else { return }
        
        list.value[index].images = []
    }
    
    func updateLocation(selectedCardId: UUID,
                        location: LocationModel) {
        
        let index = list.value.firstIndex { subcard in
            subcard.id == selectedCardId
        }
        guard let index = index else { return }
        
        list.value[index].location = location
        
    }
}
