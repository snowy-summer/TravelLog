//
//  SubCard.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

struct SubCard: Identifiable {
    var id = UUID()
    var title: String
    var stars: Int
    var money: Int
    var images: [UIImage]
    var script: String
}

extension SubCard: Hashable {
    
    static func == (lhs: SubCard, rhs: SubCard) -> Bool {
        lhs.id.hashValue == rhs.id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
