//
//  ErrorCase.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/03.
//

import Foundation

enum CurrencySystemError: Int, Error {
    case success = 1
    case dataCodeError = 2
    case authorizationCodeError = 3
    case overToRequest = 4
    
    var description: String {
        switch self {
        case .success:
            return "성공"
        case .dataCodeError:
            return "데이터 코드 에러"
        case .authorizationCodeError:
            return "인증 코드 에러"
        case .overToRequest:
            return "요청 횟수 초과"
        }
    }
}

enum JSONConverterError: Error {
    case failToEncoding
    case failToDecoding
    
    var description: String {
        switch self {
        case .failToEncoding:
            return "인코딩 실패"
        case .failToDecoding:
            return "디코딩 실패"
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case wrongStatusCode
    
    var description: String {
        switch self {
        case .invalidURL:
            return "잘못된 url입니다."
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .wrongStatusCode:
            return "잘못된 응답 코드 입니다."
        }
    }
}

enum CoreDataError: Error {
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
