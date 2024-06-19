//
//  MainCollectionView.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

final class MainCollectionView: UICollectionView {
    
    private var mainViewModel: MainViewModelProtocol
    weak var collectionViewDelegate: MainCollectionViewDelegate?
    
    init(frame: CGRect,
         mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        self.register(MainCardCell.self,
                      forCellWithReuseIdentifier: MainCardCell.identifier)
        self.collectionViewLayout = createBasicCompositionalLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainCollectionView {
    
    func configureAutoLayout(superView: UIView) {
        superView.addSubview(self)
        
        self.snp.makeConstraints { make in
            make.top.equalTo(superView.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(superView.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(superView.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(superView.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    private func createBasicCompositionalLayout() -> UICollectionViewCompositionalLayout{
        var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        
        layoutConfiguration.leadingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            
            guard let selectedId = self?.mainViewModel.list.value[indexPath.row].id else {
                return UISwipeActionsConfiguration()
            }
            
            let bookmarkAction = UIContextualAction(style: .normal,
                                                    title: nil) { action, view, completion in
                self?.mainViewModel.bookmarkCard(id: selectedId)
                
                completion(true)
            }
            
            guard let isBookmarked = self?.mainViewModel.list.value[indexPath.row].isBookMarked else {
                return  UISwipeActionsConfiguration(actions: [bookmarkAction])
            }
            
            bookmarkAction.image = isBookmarked ? .customBookmarkOn : .customBookmarkOff
            
            bookmarkAction.backgroundColor = .basic
            
            let configuration = UISwipeActionsConfiguration(actions: [bookmarkAction])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        }
        
        layoutConfiguration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            
            guard let selectedId = self?.mainViewModel.list.value[indexPath.row].id else {
                return UISwipeActionsConfiguration()
            }
            
            let deleteAction = UIContextualAction(style: .normal,
                                                  title: nil) { action, view, completion in
                self?.mainViewModel.deleteCard(id: selectedId)
                completion(true)
            }
            
            let editAction = UIContextualAction(style: .normal,
                                                title: nil) { action, view, completion in
                self?.collectionViewDelegate?.presentEditViewController(id: selectedId)
                completion(true)
            }
            
            deleteAction.image = UIImage(resource: .deleteButton)
            deleteAction.backgroundColor = .basic
            
            editAction.image = UIImage(resource: .editButton)
            editAction.backgroundColor = .basic
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        }
        
        layoutConfiguration.backgroundColor = .basic
        layoutConfiguration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
        
        return layout
    }
    
}

