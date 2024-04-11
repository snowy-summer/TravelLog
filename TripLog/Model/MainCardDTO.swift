//
//  MainCardDTO.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

struct MainCardDTO: Identifiable {
    
    var id: UUID = UUID()
    var title: String?
    var image: UIImage?
    var isBookMarked = false
    var date: Date = Date.now
    var subCards: [SubCardModelDTO]
    
}

extension MainCardDTO: Hashable {
    
    static func == (lhs: MainCardDTO, rhs: MainCardDTO) -> Bool {
        lhs.id.hashValue == rhs.id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
