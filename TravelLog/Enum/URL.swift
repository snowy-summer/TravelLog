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
        case .currency:
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
            parameters.updateValue("AP01",
                                   forKey: "data")
            return parameters
        }
    }
}
