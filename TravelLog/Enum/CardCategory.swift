//
//  Category.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/02.
//

import UIKit

enum CardCategory: String, CaseIterable {
    case transportation = "교통"
    case hotel = "숙소"
    case food = "음식"
    case activity = "활동"
   
    var image: UIImage? {
        switch self {
            
        case .transportation:
            return UIImage(systemName: "airplane.departure")
        case .hotel:
            return UIImage(systemName: "bed.double.fill")
        case .food:
            return UIImage(systemName: "fork.knife")
        case .activity:
            return UIImage(systemName: "figure.open.water.swim")
            
        }
    }
    
}
