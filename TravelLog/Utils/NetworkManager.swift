//
//  NetworkManager.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/03.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func getData(url: URL?) async throws -> Data
    
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let session: URLSessionProtocol = URLSession.shared
    
    func getData(url: URL?) async throws -> Data {
        guard let url = url else { throw NetworkError.invalidURL }
        
        let (data, response) = try await session.getData(from: url)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw NetworkError.invalidResponse
        }
        
        guard (200..<300) ~= statusCode else {
            print(statusCode)
            throw NetworkError.invalidResponse
        }
        
        return data
    }
    
}


