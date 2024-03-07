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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .basic
        
        collectionView.configureAutoLayout(superView: view)
        configureNavigationBar()
        bind()
    }
    
}

extension MainCardViewController {
    
    private func bind() {
        viewModel.list.observe { subCards in
            
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
}
