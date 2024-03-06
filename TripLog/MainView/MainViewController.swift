//
//  MainViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/27.
//

import UIKit

protocol CellDelegate: AnyObject {
    func deleteCard(id: UUID)
    func editCard(id: UUID)
    func shareCard(id: UUID)
    func bookmarkCard(id: UUID)
}

protocol MainCollectionViewDelegate: AnyObject {
    func goToEditView(index: Int)
    func deleteAction(index: Int)
    func switchBookmarkState(index: Int)
    func isBookmarked(index: Int) -> Bool
}

final class MainViewController: UIViewController {
    
    private lazy var mainCollectionView = MainCollectionView(frame: .zero)
    private lazy var addButton = UIButton()
    private let mainViewModel: MainViewModelProtocol = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .basic
        
        mainCollectionView.collectionViewDelegate = self
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
        let modalNavigationController = UINavigationController(rootViewController: EditOfMainCardViewController(mainViewmodel: mainViewModel))
        self.present(modalNavigationController, animated: true)
    }
    
}

//MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
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
    
}

//MARK: - CellDelegate

extension MainViewController: CellDelegate {
    
    func editCard(id: UUID) {
        let modalNavigationController = UINavigationController(rootViewController: EditOfMainCardViewController(mainViewModel: mainViewModel, id: id))
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
    
    func goToEditView(index: Int) {
        let id = mainViewModel.list.value[index].id
        let modalNavigationController = UINavigationController(rootViewController: EditOfMainCardViewController(mainViewModel: mainViewModel, id: id))
        self.present(modalNavigationController, animated: true)
    }
    
    func deleteAction(index: Int) {
        mainViewModel.deleteCard(id: mainViewModel.list.value[index].id)
    }
    
    func switchBookmarkState(index: Int) {
        mainViewModel.bookmarkCard(id: mainViewModel.list.value[index].id)
    }
    
    func isBookmarked(index: Int) -> Bool {
        return mainViewModel.list.value[index].isBookMarked
    }
    
}
