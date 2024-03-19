//
//  InformationViewDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/19.
//

import Foundation

protocol InformationViewDelegate: AnyObject {
    
    func backToViewController(location: LocationModel)
    func hideInformationView()
    
}
