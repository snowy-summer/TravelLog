//
//  MainViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

final class MainViewModel {
    
    var list: Observable<[MainCard]> = Observable([])

}

extension MainViewModel {
    
    func appendCard(title: String,
                    mainImage: UIImage?){
        let mainCard = MainCard(title: title,
                                isBookMarked: false,
                                subCard: [])
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
