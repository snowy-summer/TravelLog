//
//  URLList.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/03.
//

import Foundation

enum URLList {
    case currency
    
    var scheme: String {
        switch self {
        default:
            return "https"

        }
    }
    
    var host: String {
        switch self {
        case .currency:
            return "www.koreaexim.go.kr"
        }
    }
    
    var path: String {
        switch self {
        case .currency:
            return "/site/program/financial/exchangeJSON"
        }
    }
    
    var parameter: [String: String] {
        switch self {
        case .currency:
            var parameters = [String: String]()
            let apiKey = Bundle.main.apiKey
            parameters.updateValue(apiKey,
                                   forKey: "authkey")
            parameters.updateValue("AP01",
                                   forKey: "data")
            return parameters
        }
    }
    
    var url: URL? {
        switch self {
        case .currency:
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path
            components.queryItems = parameter.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            
            return components.url
        }
    }
}
