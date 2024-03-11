//
//  CircularLayout.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class CircularLayout: UICollectionViewLayout {
    
    var attributesList = [CircularLayoutAttributes]()
    let itemSize: CGSize
    
    var radius: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }
    
    var angleAtExtreme: CGFloat {
        guard let collectionView = collectionView else { return 0.0}
        
        if collectionView.numberOfItems(inSection: 0) > 0 {
            return -CGFloat(collectionView.numberOfItems(inSection: 0) - 1) * anglePerItem
        }
        
        return 0.0
    }
    
    var angle: CGFloat {
        guard let collectionView = collectionView else { return 0.0 }
        let extraContentWidth = collectionViewContentSize.width - CGRectGetWidth(collectionView.bounds)
        let angle = angleAtExtreme * collectionView.contentOffset.x / extraContentWidth
        
        return angle
    }
    
    override class var layoutAttributesClass: AnyClass {
        return CircularLayoutAttributes.self
    }
    
    init(itemSize: CGSize, radius: CGFloat) {
        self.itemSize = itemSize
        self.radius = radius
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CircularLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let collectionViewWidth = CGRectGetWidth(collectionView.bounds)
        let centerX = collectionView.contentOffset.x + (collectionViewWidth / 2.0)
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
        
        attributesList = (0..<itemCount).map { (i) ->
            CircularLayoutAttributes in
            
            let attributes = CircularLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            
            attributes.size = itemSize
            attributes.center = CGPoint(x: centerX,
                                        y: CGRectGetMidY(collectionView.bounds))
            
            attributes.angle = angle + (anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
        
            return attributes
        }
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return CGSize()}
        let width = CGFloat(collectionView.numberOfItems(inSection: 0)) * itemSize.width
        let height = CGRectGetHeight(collectionView.bounds)

        return CGSize(width: CGFloat(width), height: height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}



