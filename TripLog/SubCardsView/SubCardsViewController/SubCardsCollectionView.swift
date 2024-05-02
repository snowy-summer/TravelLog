//
//  SubsCardsCollectionView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

protocol SubCardsCollectionViewDelegate: AnyObject {
    
    func saveSnapshot(id: [UUID])
    func configureDataSource()
}

final class SubCardsCollectionView: UICollectionView {
    
    private let viewModel: SubCardsViewModel
    weak var subCardsCollectionViewDelegate: SubCardsCollectionViewDelegate?
    
    override var collectionViewLayout: UICollectionViewLayout {
        didSet {
            subCardsCollectionViewDelegate?.configureDataSource()
            subCardsCollectionViewDelegate?.saveSnapshot(id: viewModel.list.value.map{ $0.id })
        }
    }
    
    init(viewModel: SubCardsViewModel,
         size: CGSize) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
