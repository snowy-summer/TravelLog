//
//  SubsCardsCollectionView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class SubCardsCollectionView: UICollectionView {
    
    private let viewModel: SubCardsViewModel
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    init(viewModel: SubCardsViewModel, size: CGSize) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = CircularLayout(itemSize: CGSize(width: size.width * 0.8,
                                                                    height: size.height * 0.6),
                                                   radius: size.height)
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SubCardsCollectionView {
    
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
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SubCardCell, UUID>  { [weak self] cell, indexPath, itemIdentifier in
            guard let self = self else { return }
            let tupleArray = self.viewModel.list.value.map {($0.id, $0)}
            let subCardDictionary: [UUID: SubCardModel] = Dictionary(uniqueKeysWithValues: tupleArray)
           
            guard let subCard = subCardDictionary[itemIdentifier] else { return }
            
            cell.updateContent(title: subCard.title,
                               images: subCard.images,
                               starState: subCard.starsState,
                               script: subCard.script)
           
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, UUID>(collectionView: self,
                                                                               cellProvider: { 
            collectionView, indexPath, uuid in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: uuid)
        })
    
    }
    
    func saveSnapshot(id: [UUID]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(id,toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
}

enum Section {
    case main
}
