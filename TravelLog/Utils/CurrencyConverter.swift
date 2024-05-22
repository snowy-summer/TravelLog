//
//  CurrencyConverter.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/05.
//

import Foundation


struct CurrencyConverter {
    private let userDefaults = UserDefaults.standard
    
    func calculateCurrencyRate(currency: CurrencyList) -> Double?{
        let currencyName = currency.rawValue
        
        guard let currencyRate = userDefaults.object(forKey: currencyName) as? String,
              let currentCurrency = userDefaults.object(forKey: "currentCurrency") as? String,
              var rate = Double(currencyRate.split(separator: ",").joined()),
              currentCurrency != currencyName else { return nil }
        
        if currencyName == "KRW" {
            guard let rateString = userDefaults.object(forKey: currentCurrency) as? String,
                  let rateDouble = Double(rateString.split(separator: ",").joined()) else { return nil }
            
            rate = 1 / rateDouble
        }
        
        if currencyName != "KRW" && currentCurrency != "KRW" {
            guard let currentRateString = userDefaults.object(forKey: currentCurrency) as? String,
                  let targetRateString = userDefaults.object(forKey: currencyName) as? String,
                  let currentRate = Double(currentRateString.split(separator: ",").joined()),
                  let targetRate = Double(targetRateString.split(separator: ",").joined()) else { return nil }
            
            let rateToKRW = 1 / currentRate
            let rateFromKRWToTarget = targetRate
            
            
            rate = rateToKRW * rateFromKRWToTarget
        }
        
        return rate
        
    }
}
