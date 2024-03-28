//
//  SearchLocationViewControllerDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/21.
//

import Foundation
import CoreLocation

protocol SearchLocationViewDelegate: AnyObject {
    
    func changeModalMaxConstraint()
    func changeModalLowConstraint()
    
}
