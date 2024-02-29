//
//  MainCollectionView.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

final class MainCollectionView: UICollectionView {
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.register(MainCardCell.self,
                      forCellWithReuseIdentifier: MainCardCell.identifier)
        self.collectionViewLayout = createBasicCompositionalLayout()
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainCollectionView {
    
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
    
    private func createBasicCompositionalLayout() -> UICollectionViewCompositionalLayout{
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
}

//MARK: - CollectionViewDelegate, UICollectionViewDataSource

extension MainCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: MainCardCell.identifier,
                                                  for: indexPath) as? MainCardCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}
