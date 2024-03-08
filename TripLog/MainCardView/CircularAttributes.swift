//
//  CircularAttributes.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class CircularLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle * 100000)
            transform = CGAffineTransformMakeRotation(angle)
        }
    }

    convenience init(anchorPoint: CGPoint, forCellWith: IndexPath) {
        self.init(forCellWith: forCellWith)
        self.anchorPoint = anchorPoint
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes = super.copy(with: zone) as! CircularLayoutAttributes
        
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        
        return copiedAttributes
    }
}
