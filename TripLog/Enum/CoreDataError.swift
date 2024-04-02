//
//  CoreDataError.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/02.
//

import Foundation

enum CoreDataError: Error,CustomStringConvertible {
    case failToreadMainCard
    
    var description: String {
        switch self {
        case .failToreadMainCard:
            return "파일을 불러오는데 실패했습니다."
        }
    }
}
