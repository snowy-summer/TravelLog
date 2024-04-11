//
//  ContentsOfCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/11.
//

import UIKit

enum ContentsOfCell: Hashable {
    case title(String?)
    case images(UIImage?)
    case starsState([Bool])
    case price(Double?)
    case location(LocationDTO?)
    case category(CardCategory?)
    case script(String?)
}
