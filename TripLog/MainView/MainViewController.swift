//
//  MainViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/27.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var mainCollectionView = MainCollectionView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.configureAutoLayout(superView: view)
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCardCell.identifier, for: indexPath) as? MainCardCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .blue
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
}
