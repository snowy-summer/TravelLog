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
        
        let networkManager = NetworkManager()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY / MM / dd"
        
        Task {
            do {
                let jsonData = try await networkManager.getData(url:URLList.currency.url)
                let decodedData = try JSONConverter.decode(type: [CurrencyDTO].self,
                                                           data: jsonData)
                
                let userDefaults = UserDefaults.standard
                if let date = userDefaults.object(forKey: "lastUpdateDate") as? String {
                    
                    if date != formatter.string(from: Date.now){
                    
                        userDefaults.set(formatter.string(from: Date.now),
                                         forKey: "lastUpdateDate")
                        
                        decodedData.forEach { currency in
                            userDefaults.set(currency.exchangeRate,
                                             forKey: currency.currencyUnit)
                        }
                   }
                } else {
                    userDefaults.set(formatter.string(from: Date.now),
                                     forKey: "lastUpdateDate")
                
                    decodedData.forEach { currency in
                        userDefaults.set(currency.exchangeRate,
                                         forKey: currency.currencyUnit)
                    }
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

