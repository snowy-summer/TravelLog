//
//  JSONConverter.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/03.
//

import Foundation

struct JSONConverter {
    
    static func encode<T: Encodable>(data: T) throws -> Data {
        let encoder = JSONEncoder()
        
        guard let encodedData = try? encoder.encode(data) else {
            throw JSONConverterError.failToEncoding
        }
        
        return encodedData
    }
    
    static func decode<T: Decodable>(type: T.Type, data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(type,
                                                    from: data) else {
            throw JSONConverterError.failToDecoding
        }
        
        return decodedData
    }
}
