//
//  MainCardCollectionView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class MainCardCollectionView: UICollectionView {
    
    private let viewModel: SubCardsViewModel
    
    init(viewModel: SubCardsViewModel, size: CGSize) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = CircularLayout(itemSize: CGSize(width: size.width * 0.3,
                                                                    height: size.height * 0.3),
                                                   radius: 500)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAutoLayout(superView: UIView) {
        superView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = superView.safeAreaLayoutGuide
        let constraints = [
            self.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }

}
