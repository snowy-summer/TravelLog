//
//  MainViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/27.
//

import UIKit

final class MainViewController: UIViewController {
    
    private lazy var mainCollectionView = MainCollectionView(frame: .zero)
    private let mainViewModel = MainViewModel()
    private lazy var addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.configureAutoLayout(superView: view)
        
        configureAddButton()
        bind()
    }

}

extension MainViewController {
    
    private func configureAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(resource: .plusButton), for: .normal)
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.addTarget(self,
                            action: #selector(tapAddButton),
                            for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        let addButtonConstraints = [
            addButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                              constant: -view.bounds.height * 0.01),
            addButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                             multiplier: 0.2),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(addButtonConstraints)
        
    }
    
    private func bind() {
        mainViewModel.list.observe { [weak self] mainCards in
            //값이 변하면 일어나는일
            guard let self = self else { return }
            self.mainCollectionView.reloadData()
        }
    }
    
    @objc private func tapAddButton() {
        let modalNavigationController = UINavigationController(rootViewController: EditOfVMainCardViewController(mainViewmodel: mainViewModel))
        self.present(modalNavigationController, animated: true)
    }
    
}

//MARK: - CollectionViewDelegate, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
//        guard let count = mainDelgate?.dd() else { return 0 }
        let count = mainViewModel.list.value.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCardCell.identifier,
                                                  for: indexPath) as? MainCardCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}
