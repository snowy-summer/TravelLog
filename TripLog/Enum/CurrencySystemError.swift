//
//  CurrencyRequestResult.swift
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
