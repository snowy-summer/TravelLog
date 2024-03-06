//
//  MainViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import Foundation

protocol MainViewModelProtocol {
    var list: Observable<[MainCard]> { get }
    func appendCard(mainCard: MainCard)
    func deleteCard(id: UUID)
    func bookmarkCard(id: UUID)
}

final class MainViewModel {
    
    var list: Observable<[MainCard]> = Observable([])

}

extension MainViewModel: MainViewModelProtocol {
  
    func appendCard(mainCard: MainCard){
        list.value.append(mainCard)
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
    
}
