//
//  URLSession+Extenssion.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/03.
//

import Foundation

protocol URLSessionProtocol {
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
    
    func getData(from url: URL) async throws -> (Data, URLResponse)
}

protocol URLSessionDataTaskProtocol {
    
    func resume()
    
}


extension URLSession: URLSessionProtocol {
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
    
    func getData(from url: URL) async throws -> (Data, URLResponse) {
        return try await data(from: url)
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}
