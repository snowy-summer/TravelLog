//
//  MainViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit



final class MainCardsViewModel {
    
    var list: Observable<[MainCardDTO]> = Observable([])
    
    let mainDataManager = MainDataManager()

}

extension MainCardsViewModel: MainViewModelProtocol {
  
    func appendMainCard(title: String, image: UIImage?) {
        list.value.append(MainCardDTO(title: title,image: image, subCards: []))
    }
    
    func changeSubCards(id: UUID, cards: [SubCardModelDTO]) {
        let index = list.value.firstIndex { mainCard in
            mainCard.id == id
        }
        guard let index = index else { return }
        list.value[index].subCards = cards
    }
    
    func deleteCard(id: UUID) {
        list.value = list.value.filter{ $0.id != id }
        do {
            try mainDataManager.deleteMainCard(id: id)
        } catch {
            print(error)
        }
    }
    
    func bookmarkCard(id: UUID) {
        let index = list.value.firstIndex { mainCard in
            mainCard.id == id
        }
        guard let index = index else { return }
        list.value[index].isBookMarked = !list.value[index].isBookMarked
    }
    
    func editMainCardTitle(id: UUID, title: String) {
        let index = list.value.firstIndex { mainCard in
            mainCard.id == id
        }
        guard let index = index else { return }
        list.value[index].title = title
    }
    
    func editMainCardImage(id: UUID, image: UIImage?) {
        let index = list.value.firstIndex { mainCard in
            mainCard.id == id
        }
        guard let index = index else { return }
        list.value[index].image = image
    }
    
    func editMainCardDate(id: UUID, date: Date) {
        let index = list.value.firstIndex { mainCard in
            mainCard.id == id
        }
        guard let index = index else { return }
        list.value[index].date = date
    }
}
