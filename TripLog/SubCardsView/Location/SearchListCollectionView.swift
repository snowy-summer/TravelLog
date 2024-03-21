//
//  SearchListCollectionView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import UIKit

final class SearchListCollectionView: UICollectionView {
    
    private var locationViewModel: SearchLocationViewModel
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    init(locationViewModel: SearchLocationViewModel) {
        self.locationViewModel = locationViewModel
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = createBasicLayout()
        
        configureDataSource()
        print("SearchListCollectionView 생성")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("SearchListCollectionView 끝~~~~~~~~~~~~~~~~~~~~~")
    }

}

extension SearchListCollectionView {
    
    private func createBasicLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        layoutConfiguration.backgroundColor = .basic
        
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<LocationListCell, UUID>  { [weak self] cell, indexPath, itemIdentifier in
            guard let self = self else { return }
            
            let tupleArray = self.locationViewModel.list.value.map {($0.id, $0)}
            let subCardDictionary: [UUID: LocationModel] = Dictionary(uniqueKeysWithValues: tupleArray)
            
            guard let location = subCardDictionary[itemIdentifier],
                  let mapitem = location.mapItem else { return }
            
            let symbolIcon = location.mapItem?.pointOfInterestCategory?.symbolName
                ?? UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.red,
                                                                            renderingMode: .alwaysOriginal)
            
            cell.updateContent(title: mapitem.name,
                               subtitle: mapitem.placemark.title,
                               iconImage: symbolIcon)

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
