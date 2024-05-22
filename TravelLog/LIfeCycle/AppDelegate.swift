//
//  AppDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let networkManager: NetworkManagerProtocol = NetworkManager()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM / dd"
        
        Task {
            do {
                let userDefaults = UserDefaults.standard
                let today = formatter.string(from: Date.now)
                
                if let lastUpdateDate = userDefaults.object(forKey: "lastUpdateDate") as? String ,
                   lastUpdateDate == today { return }
                
                let jsonData = try await networkManager.getData(url:URLList.currency.url)
                let decodedData = try JSONConverter.decode(type: [CurrencyDTO].self,
                                                           data: jsonData)
                
                userDefaults.set(today,
                                 forKey: "lastUpdateDate")
                
                for currency in decodedData {
                    if currency.currencyUnit == CurrencyList.JPY.rawValue {
                        let jpyRate = Double(currency.exchangeRate.split(separator: ",").joined())! / 100
                        userDefaults.set( String(jpyRate),
                                          forKey: currency.currencyUnit)
                        continue
                    }
                    
                    userDefaults.set(currency.exchangeRate,
                                     forKey: currency.currencyUnit)
                }

            } catch {
                print(error)
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
    
    
}

