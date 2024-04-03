//
//  CoreDataError.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/02.
//

import Foundation

enum CoreDataError: Error,CustomStringConvertible {
    case failToReadMainCard
    case failToSaveContext
    
    var description: String {
        switch self {
        case .failToReadMainCard:
            return "파일을 불러오는데 실패했습니다."
        case .failToSaveContext:
            return "파일을 저장하는데 실패했습니다."
        }
    }
}
