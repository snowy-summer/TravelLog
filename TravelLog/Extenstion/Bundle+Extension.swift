//
//  Bundle+Extension.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/03.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("APIKeys.plist를 찾지 못했습니다..")
        }
        guard let value = plistDict.object(forKey: "CurrencyAPIKey") as? String else {
            fatalError("api key를 찾지 못했습니다.")
        }
        
        return value
    }
}
