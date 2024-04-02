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
    
    override var collectionViewLayout: UICollectionViewLayout {
        didSet {
            configureDataSource()
            saveSnapshot(id: viewModel.list.value.map{ $0.id })
        }
    }
    
    init(viewModel: SubCardsViewModel,
         size: CGSize) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = createBasicCompositionalLayout()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Method
    
    func saveSnapshot(id: [UUID]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(id,toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func createBasicCompositionalLayout() -> UICollectionViewCompositionalLayout{
        var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        
        layoutConfiguration.backgroundColor = .basic
        layoutConfiguration.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
        
        return layout
    }
    
    func changeLayout() {
        if collectionViewLayout is CircularLayout {
            collectionViewLayout = createBasicCompositionalLayout()
        } else {
            collectionViewLayout = CircularLayout(itemSize: CGSize(width: self.bounds.width * 0.8,
                                                                  height: self.bounds.height * 0.6),
                                                 radius: self.bounds.height)
        }
    }
    
}

//MARK: - Configuration

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
        let cardCellRegistration = UICollectionView.CellRegistration<SubCardCell, UUID> { [weak self] cell, indexPath, itemIdentifier in
            guard let self = self else { return }
            let tupleArray = self.viewModel.list.value.map {($0.id, $0)}
            let subCardDictionary: [UUID: SubCardModel] = Dictionary(uniqueKeysWithValues: tupleArray)
            
            guard let subCard = subCardDictionary[itemIdentifier] else { return }
            
            cell.updateContent(title: subCard.title,
                               images: subCard.images,
                               starState: subCard.starsState)
            
        }
        
        let listCellRegistration = UICollectionView.CellRegistration<SubCardListCell, UUID> { 
            [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            
            let tupleArray = self.viewModel.list.value.map {($0.id, $0)}
            let subCardDictionary: [UUID: SubCardModel] = Dictionary(uniqueKeysWithValues: tupleArray)
            
            guard let subCard = subCardDictionary[itemIdentifier] else { return }
            
            cell.updateCotent(images: subCard.images,
                              title: subCard.title,
                              price: subCard.price,
                              starState: subCard.starsState)
            
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, UUID>(collectionView: self,
                                                                               cellProvider: { 
            [weak self] collectionView, indexPath, uuid in
            
            if self?.collectionViewLayout is CircularLayout {
                
                return collectionView.dequeueConfiguredReusableCell(using: cardCellRegistration,
                                                                    for: indexPath,
                                                                    item: uuid)
            } else {
                
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration,
                                                                    for: indexPath,
                                                                    item: uuid)
            }
        })
    }
    
}
