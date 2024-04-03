//
//  SubCardModelDTO.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

struct SubCardModelDTO: Identifiable {
    var id: UUID = UUID()
    var title: String?
    var starsState: [Bool] = [Bool](repeating: false, count: 5)
    var price: Int?
    var images: [UIImage]?
    var script: String?
    var category: CardCategory?
    var location: LocationDTO?
}

extension SubCardModelDTO: Hashable {
    
    static func == (lhs: SubCardModelDTO, rhs: SubCardModelDTO) -> Bool {
        lhs.id.hashValue == rhs.id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
