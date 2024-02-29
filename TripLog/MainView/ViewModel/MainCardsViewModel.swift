//
//  MainViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

protocol MainViewModelProtocol {
    func appendCard(mainCard: MainCard)
    func deleteCard(id: UUID)
    func bookMarkCard(mainCard: MainCard)
    func editCard()
}

final class MainViewModel {
    
    var list: Observable<[MainCard]> = Observable([])

}

extension MainViewModel: MainViewModelProtocol {
    func createMainCard(title: String,
                        sumbnailImage: UIImage?) -> MainCard {
        let mainCard = MainCard(title: title,
                                subCard: [])
        return mainCard
    }
    
    func appendCard(mainCard: MainCard){
        list.value.append(mainCard)
    }
    
    func deleteCard(id: UUID) {
        list.value = list.value.filter{ $0.id != id }
    }
    
    func bookMarkCard(mainCard: MainCard) {
        
    }
    
    func editCard() {
        
    }
    
}
