//
//  MapViewControllerDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/20.
//

import Foundation

protocol MapViewControllerDelegate: AnyObject {
    
    func updateLocation(location: LocationModel)
    
}
