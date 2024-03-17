//
//  MainCardDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import Foundation

protocol MainCardDelegate: AnyObject {
    
    func changeSubCards(mainCardId: UUID, card: [SubCard])
    
}
