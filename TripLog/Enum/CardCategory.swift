//
//  Category.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/02.
//

import UIKit

enum CardCategory: String, CaseIterable {
    case hotel = "숙소"
    case food = "음식"
    case activity = "활동"
    
    var color: UIColor {
        switch self {
        case .hotel:
            return UIColor(resource: .hotel)
        case .food:
            return UIColor(resource: .food)
        case .activity:
            return UIColor(resource: .activity)
        }
    }
    
}
