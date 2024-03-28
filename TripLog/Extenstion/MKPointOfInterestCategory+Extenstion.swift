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
                                                                      .nightlife,
                                                                      .museum,
                                                                      .park,
                                                                      .beach,
                                                                      .foodMarket]
    
    var symbolIcon: UIImage? {
        switch self {
            
        case .airport:
            return .airport
        case .publicTransport:
            return .publicTransport.withRenderingMode(.alwaysOriginal)
            
        case .bakery:
            return .bakery.withRenderingMode(.alwaysOriginal)
        case .brewery, .nightlife, .winery:
            return .brewery.withRenderingMode(.alwaysOriginal)
        case .cafe:
            return .cafe.withRenderingMode(.alwaysOriginal)
        case .restaurant:
            return .restaurant.withRenderingMode(.alwaysOriginal)
            
        case .museum:
            return .museum.withRenderingMode(.alwaysOriginal)
        case .park:
            return .park.withRenderingMode(.alwaysOriginal)
        case .beach:
            return .beach.withRenderingMode(.alwaysOriginal)
            
        case .hotel:
            return .hotel.withRenderingMode(.alwaysOriginal)
        case .foodMarket:
            return .foodMarket.withRenderingMode(.alwaysOriginal)
            
        default:
            return UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.red,
                                                                            renderingMode: .alwaysOriginal)
        }
    }
    
    var annotationSymbol: UIImage? {
        switch self {
            
        case .airport:
            return UIImage(systemName: "airplane")
        case .publicTransport:
            return .publicTrasportAnnotation
            
        case .bakery:
            return .breadAnnotation
        case .brewery, .nightlife, .winery:
            return .beerAnnotation
        case .cafe:
            return .caffeAnnotation
        case .restaurant:
            return .restaurantAnnotation
            
        case .museum:
            return .museumAnnotation
        case .park:
            return .parkAnnotation
        case .beach:
            return .beachAnnotation
            
        case .hotel:
            return .hotelAnnotation
        case .foodMarket:
            return .marketAnnotation
            
        default:
            return UIImage(systemName: "mappin.and.ellipse")
        }
    }

    var annotationColor: UIColor? {
        switch self {
            
        case .airport, .publicTransport:
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            
        case .bakery, .restaurant, .cafe:
            return #colorLiteral(red: 0.9733965993, green: 0.6844152212, blue: 0.3743609786, alpha: 1)
        case .brewery, .nightlife, .winery:
            return #colorLiteral(red: 0.9884051681, green: 0.8687084317, blue: 0.1805729866, alpha: 1)
            
        case .museum:
            return #colorLiteral(red: 0.6574974656, green: 0.6574974656, blue: 0.6574974656, alpha: 1)
        case .park:
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .beach:
            return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            
        case .hotel:
            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case .foodMarket:
            return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            
        default:
            return .lightGray
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
        case .brewery, .nightlife, .winery:
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
