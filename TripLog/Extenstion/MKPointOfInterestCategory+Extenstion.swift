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
                                                                      .hotel,
                                                                      .airport,
                                                                      .publicTransport,
                                                                      .museum,
                                                                      .park,
                                                                      .beach,
                                                                      .foodMarket]
    
    var symbolName: UIImage? {
        switch self {
            
        case .airport:
            return .airport
        case .publicTransport:
            return .publicTransport
            
        case .bakery:
            return .bakery
        case .brewery, .winery:
            return .brewery
        case .cafe:
            return .cafe
        case .restaurant:
            return .restaurant
            
        case .museum:
            return .museum
        case .park:
            return .park
        case .beach:
            return .beach
            
        case .hotel:
            return .hotel
        case .foodMarket:
            return .foodMarket
            
        default:
            return UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.red,
                                                                            renderingMode: .alwaysOriginal)
        }
    }
    
    var categoryName: String? {
        switch self {
            
        case .airport:
            return "공항"
        case .publicTransport:
            return "지하철"
            
        case .bakery:
            return "빵집"
        case .brewery, .winery:
            return "술집"
        case .cafe:
            return "카페"
        case .restaurant:
            return "식당"
            
        case .museum:
            return "박물관"
        case .park:
            return "공원"
        case .beach:
            return "해변"
            
        case .hotel:
            return "숙소"
        case .foodMarket:
            return "마켓"
            
        default:
            return ""
        }
    }
}
