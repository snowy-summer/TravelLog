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
        mainCollectionView.configureAutoLayout(superView: view)
    }

}
