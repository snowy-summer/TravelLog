//
//  MainCard.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

struct MainCardModel: Identifiable {
    
    var id: UUID = UUID()
    var title: String?
    var image: UIImage?
    var isBookMarked = false
    var date: Date = Date.now
    var subCards: [SubCardModel]
    
}

extension MainCardModel: Hashable {
    
    static func == (lhs: MainCardModel, rhs: MainCardModel) -> Bool {
        lhs.id.hashValue == rhs.id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
