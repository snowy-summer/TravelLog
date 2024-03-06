//
//  MainCardViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/06.
//

import UIKit

class MainCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .basic
    }
    
}

extension MainCardViewController {
    
    private func configureNavigationBar() {
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                         style: .plain,
                                         target: self,
                                         action: nil)
        navigationItem.rightBarButtonItem = menuButton
        configureBarButtonMenu(button: menuButton)
    }
    
    private func configureBarButtonMenu(button: UIBarButtonItem) {

        button.menu = UIMenu(children: [])
    }
}
