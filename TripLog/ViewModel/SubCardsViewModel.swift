//
//  SubCardsViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/06.
//
import UIKit

final class SubCardsViewModel {
    
    var list: Observable<[SubCardModelDTO]> = Observable([])
    
    var editingSubCard: Observable<SubCardModelDTO> = Observable(SubCardModelDTO())
    
    var title: Observable<String?> = Observable(nil)
    var starsState: Observable<[Bool]> = Observable([Bool](repeating: false, count: 5))
    var price: Observable<Double?> = Observable(nil)
    var currency: Observable<CurrencyList> = Observable(CurrencyList.KRW)
    var location: Observable<LocationDTO?> = Observable(nil)
    var category: Observable<CardCategory?> = Observable(nil)
    var script: Observable<String?> = Observable(nil)
    
    func updateEditingSubCard() {
        editingSubCard.value = SubCardModelDTO(title: title.value,
                                               images: editingSubCard.value.images,
                                               starsState: starsState.value,
                                               price: price.value,
                                               currency: currency.value,
                                               location: location.value,
                                               category: category.value,
                                               script: script.value)
        
    }
    
    func clearToProperty() {
        title.value = nil
        starsState.value = [Bool](repeating: false, count: 5)
        price.value = nil
        location.value = nil
        category.value = nil
        script.value = nil
    }
}

extension SubCardsViewModel {
    
    func selectCard(id: UUID) -> SubCardModelDTO? {
        let index = list.value.firstIndex { subCard in
            subCard.id == id
        }
        guard let index = index else { return nil }
        
        let card = list.value[index]
        
        return card
    }
    
    func updateSubCard(id: UUID,
                       card: SubCardModelDTO ) {
        let index = list.value.firstIndex { subCard in
            subCard.id == id
        }
        guard let index = index else { return }
        
        list.value[index] = card
        
    }
    
    func deleteSubCard(uuidsToDelete: Set<UUID>) {
        
        list.value = list.value.filter { subCard in
            !uuidsToDelete.contains(subCard.id)
        }
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
        if price?.suffix(1) == "." {
            if price?.suffix(2) != ".." { return }
        }
        
        if let price = price {
            editingSubCard.value.price = (Double(price) != nil) ? Double(price)! : nil
        }
    }
    
    func updateEditingCardCurrency(currency: CurrencyList) {
        editingSubCard.value.currency = currency
    }
    
    func updateEditingCardLocation(location: LocationDTO?) {
        editingSubCard.value.location = location
        
    }
    
    func updateEditingCardCategory(category: CardCategory) {
        editingSubCard.value.category = category
    }
    
    func updateEditingCardScript(text: String?) {
        editingSubCard.value.script = text
    }
    
}

extension SubCardsViewModel {
    
    func updatePrice(value: String?) {
        if let value = value {
            price.value = (Double(value) != nil) ? Double(value)! : price.value
        }
    }
}
