//
//  DataBaseError.swift
//  TripLog
//
//  Created by 최승범 on 2024/05/02.
//

import Foundation

enum CoreDataError: Error {
    case failToReadMainCard
    case failToSaveContext
    case failToConvertImage
    
    var description: String {
        switch self {
        case .failToReadMainCard:
            return "파일을 불러오는데 실패했습니다."
        case .failToSaveContext:
            return "파일을 저장하는데 실패했습니다."
        case .failToConvertImage:
            return "경로의 파일을 이미지로 변환하는데 실패했습니다."
        }
    }
}

enum FileManagerError: Error {
    case cantSaveImage
    case cantConvertPath
    case failToDelete
    
    var description: String {
        switch self {
        case .cantSaveImage:
            return "이미지 저장 실패했습니다."
        case .cantConvertPath:
            return "경로 추출에 실패했습니다."
        case .failToDelete:
            return "삭제에 실패했습니다."
        }
    }
}
