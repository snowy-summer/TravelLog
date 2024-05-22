//
//  Debouncer.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/26.
//

import Foundation

final class Debouncer {
    
    private let mainQueue = DispatchQueue.main
    private var workItem: DispatchWorkItem?
    private let seconds: Double
    
    init(seconds: Double) {
        self.seconds = seconds
    }
    
    func run(closure: @escaping () -> ()) {
        workItem?.cancel()
        
        let newWorkItem = DispatchWorkItem(block: closure)
        workItem = newWorkItem
        
        mainQueue.asyncAfter(deadline: .now() + seconds,
                             execute: newWorkItem)
    }
}
