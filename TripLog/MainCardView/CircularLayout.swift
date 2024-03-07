//
//  CircularLayout.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class CircularLayout: UICollectionViewLayout {
    
    let itemSize: CGSize
    
    var radius: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }
    
    var attributesList = [CircularLayoutAttributes]()
    
    init(itemSize: CGSize, radius: CGFloat) {
        self.itemSize = itemSize
        self.radius = radius
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layoutAttributesClass: AnyClass {
        return CircularLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let centerX = collectionView.contentOffset.x + (CGRectGetWidth(collectionView.bounds) / 2.0)
        
        attributesList = (0..<collectionView.numberOfItems(inSection: 0)).map { (i) ->
            CircularLayoutAttributes in
            
            let attributes = CircularLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
        
            attributes.size = self.itemSize
            attributes.center = CGPoint(x: centerX, y: CGRectGetMidY(collectionView.bounds))
 
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
   
}


