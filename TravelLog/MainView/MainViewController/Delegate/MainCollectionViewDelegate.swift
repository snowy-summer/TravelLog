//
//  MainCollectionViewDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import Foundation

protocol MainCollectionViewDelegate: AnyObject {
    
    func presentEditViewController(id: UUID)
    
}
