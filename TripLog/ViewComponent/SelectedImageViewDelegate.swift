//
//  SelectedImageViewDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/22.
//

import UIKit

protocol SelectedImageViewDelegate: AnyObject {
    
    func presentPicker(where: UIViewController)
    
}
