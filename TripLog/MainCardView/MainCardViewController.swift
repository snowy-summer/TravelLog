//
//  MainCardViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/06.
//

import UIKit

final class MainCardViewController: UIViewController {
    
    private let viewModel = SubCardsViewModel()
    private lazy var collectionView = MainCardCollectionView(viewModel: viewModel, size: view.bounds.size)
    private lazy var addButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .basic
        
        collectionView.configureAutoLayout(superView: view)
        configureNavigationBar()
        bind()
        
      configureAddButton()
        
    }
    
}

extension MainCardViewController {
    
    private func bind() {
        viewModel.list.observe { [weak self] subCards in
            self?.collectionView.saveSnapshot(id: subCards.map { $0.id } )
    
        }
    }
    
    private func configureNavigationBar() {
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                         style: .plain,
                                         target: self,
                                         action: nil)
        navigationItem.rightBarButtonItem = menuButton
        configureBarButtonMenu(button: menuButton)
    }
    
    private func configureBarButtonMenu(button: UIBarButtonItem) {
        
        let changeLayout = UIAction(title: "갤러리로 보기",
                                    image: UIImage(systemName: "square.grid.2x2.fill")) { action in
            
        }
        
        let select = UIAction(title: "선택",
                              image: UIImage(systemName: "checkmark.circle")  ) { action in
        }

        let items = [ 
            changeLayout,
            select
        ]
        
        button.menu = UIMenu(children: items)
    }
    
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
    
    @objc private func tapAddButton() {
        
        viewModel.list.value.append(SubCard(title: "", stars: 0, money: 0, images: [], script: ""))

    }
}
