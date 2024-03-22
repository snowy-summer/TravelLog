//
//  CellDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import Foundation

protocol CellDelegate: AnyObject {
    
    func deleteCard(id: UUID)
    func editCard(id: UUID)
    func shareCard(id: UUID)
    func bookmarkCard(id: UUID)
    
}
