//
//  SubCardModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

struct SubCardModel: Identifiable {
    var id: UUID = UUID()
    var title: String?
    var starsState: [Bool] = [Bool](repeating: false, count: 5)
    var price: Int?
    var images: [UIImage]?
    var script: String?
    var location: LocationModel?
}

extension SubCardModel: Hashable {
    
    static func == (lhs: SubCardModel, rhs: SubCardModel) -> Bool {
        lhs.id.hashValue == rhs.id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
