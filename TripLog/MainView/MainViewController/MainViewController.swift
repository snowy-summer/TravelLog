//
//  MainViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/27.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let mainViewModel: MainViewModelProtocol = MainCardsViewModel()
    
    private lazy var mainCollectionView = MainCollectionView(frame: .zero,
                                                             mainViewModel: mainViewModel)
    private lazy var addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .basic
        
        mainCollectionView.collectionViewDelegate = self
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
            guard let self = self else { return }
            self.mainCollectionView.reloadData()
        }
    }
    
    @objc private func tapAddButton() {
        let modalNavigationController = UINavigationController(rootViewController: MainCardEditViewController(mainViewmodel: mainViewModel))
        self.present(modalNavigationController, animated: true)
    }
    
}

//MARK: - UICollectionViewDataSource,UICollectionViewDelegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
    
        let count = mainViewModel.list.value.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCardCell.identifier,
                                                                for: indexPath) as? MainCardCell else {
            return MainCardCell()
        }
        
        let content = mainViewModel.list.value[indexPath.row]
        cell.delegate = self
        cell.updateContent(title: content.title,
                           image: content.image,
                           date: content.date,
                           id: content.id)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = mainViewModel.list.value[indexPath.row].id
        let subCards = mainViewModel.list.value[indexPath.row].subCards
        
        navigationController?.pushViewController(SubCardsViewController(mainCardId: id,
                                                                        delegate: self,
                                                                        subcards: subCards),
                                                 animated: true)
    }
    
}

//MARK: - CellDelegate

extension MainViewController: CellDelegate {
    
    func editCard(id: UUID) {
        let modalNavigationController = UINavigationController(rootViewController: MainCardEditViewController(mainViewModel: mainViewModel, id: id))
        self.present(modalNavigationController, animated: true)
    }
    
    func shareCard(id: UUID) {
        
    }
    
    func bookmarkCard(id: UUID) {
        mainViewModel.bookmarkCard(id: id)
    }
    
    func deleteCard(id: UUID) {
        mainViewModel.deleteCard(id: id)
    }
    
}

//MARK: - MainCollectionViewDelegate

extension MainViewController: MainCollectionViewDelegate {
    
    func presentEditViewController(id: UUID) {
        let modalNavigationController = UINavigationController(rootViewController: MainCardEditViewController(mainViewModel: mainViewModel, id: id))
        self.present(modalNavigationController, animated: true)
    }
    
}

//MARK: - SubCardsViewControllerDelegate
extension MainViewController: SubCardsViewControllerDelegate {
    
    func changeSubCards(mainCardId: UUID, card: [SubCardModel]) {
        mainViewModel.changeSubCards(id: mainCardId, cards: card)
    }
    
}
