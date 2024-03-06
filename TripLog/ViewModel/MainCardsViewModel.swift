//
//  MainViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

protocol MainViewModelProtocol {
    var list: Observable<[MainCard]> { get }
    
    func appendCard(title: String, image: UIImage?)
    func deleteCard(id: UUID)
    func bookmarkCard(id: UUID)
    func editMainCardTitle(id: UUID, title: String)
    func editMainCardImage(id: UUID, image: UIImage?)
    func editMainCardDate(id: UUID, date: Date)
}

final class MainCardsViewModel {
    
    var list: Observable<[MainCard]> = Observable([])

}

extension MainCardsViewModel: MainViewModelProtocol {
  
    func appendCard(title: String, image: UIImage?) {
        list.value.append(MainCard(title: title,image: image, subCard: []))
    }
    
    func deleteCard(id: UUID) {
        list.value = list.value.filter{ $0.id != id }
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
