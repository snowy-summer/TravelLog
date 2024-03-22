//
//  SubCardsViewControllerDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import Foundation

protocol SubCardsViewControllerDelegate: AnyObject {
    
    func changeSubCards(mainCardId: UUID, card: [SubCardModel])
    
}
