//
//  Observable.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import Foundation

final class Observable<T> {
    
    private var action: ((T) -> Void)?
    var value: T {
        didSet {
            action?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func observe(_ action: @escaping (T) -> Void) {
        self.action = action
        action(value)
    }
    
}
