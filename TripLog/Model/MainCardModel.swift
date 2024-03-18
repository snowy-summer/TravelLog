//
//  MainCard.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

struct MainCardModel {
    
    var title: String
    var image: UIImage?
    var isBookMarked = false
    var id: UUID = UUID()
    var date: Date = Date.now
    var subCards: [SubCardModel]
    
}
