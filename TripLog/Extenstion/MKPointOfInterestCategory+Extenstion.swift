//
//  MKPointOfInterestCategory+Extenstion.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/17.
//

import Foundation
import MapKit

extension MKPointOfInterestCategory {
    
    static let travelPointsOfInterest: [MKPointOfInterestCategory] = [.bakery,
                                                                      .brewery,
                                                                      .cafe,
                                                                      .restaurant,
                                                                      .winery,
                                                                      .hotel ]
    
    static let defaultPointsOfInterestSymbolName = "mappin.and.ellipse"
    
    var symbolName: String {
        switch self {
        case .airport:
            return "ariplane"
        default:
            return MKPointOfInterestCategory.defaultPointsOfInterestSymbolName
        }
    }
}
