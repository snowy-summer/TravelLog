//
//  SubCardCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class SubCardCell: UICollectionViewCell {
    
    static let identifier = "SubCardCell"
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let circularLayoutAttributes = layoutAttributes as? CircularLayoutAttributes else { return }
        self.layer.anchorPoint = circularLayoutAttributes.anchorPoint
        self.center.y += (circularLayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
    }
}
