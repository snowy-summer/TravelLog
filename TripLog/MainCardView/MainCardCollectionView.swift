//
//  MainCardCollectionView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class MainCardCollectionView: UICollectionView {
    
    private enum Section {
        case main
    }
    
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

extension MainCardCollectionView {
    
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
            let subCardDictionary: [UUID: SubCard] = Dictionary(uniqueKeysWithValues: tupleArray)
            
            cell.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 20
            guard let subCard = subCardDictionary[itemIdentifier] else { return }
           
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
        var snaphot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snaphot.appendSections([.main])
        snaphot.appendItems(id,toSection: .main)
        diffableDataSource?.apply(snaphot, animatingDifferences: false)
    }
    
}
