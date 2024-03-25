//
//  SubCardsViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/06.
//

import UIKit

final class SubCardsViewController: UIViewController {
    
    private let mainCardId: UUID
    private let viewModel = SubCardsViewModel()
    weak var delegate: SubCardsViewControllerDelegate?
    
    private lazy var collectionView = SubCardsCollectionView(viewModel: viewModel,
                                                             size: view.bounds.size)
    private lazy var addButton = UIButton()
    
    
    init(mainCardId: UUID,
         delegate: SubCardsViewControllerDelegate? = nil,
         subcards: [SubCardModel]) {
        
        self.mainCardId = mainCardId
        self.delegate = delegate
        self.viewModel.list.value = subcards
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .basic
        
        collectionView.delegate = self
        collectionView.configureAutoLayout(superView: view)
        configureNavigationBar()
        bind()
        configureAddButton()
        
    }
}

extension SubCardsViewController {
    
    private func bind() {
        viewModel.list.observe { [weak self] subCards in
            guard let self = self else { return }
            self.collectionView.saveSnapshot(id: subCards.map { $0.id } )
            self.delegate?.changeSubCards(mainCardId: mainCardId, card: subCards)
        }
    }
    
    @objc private func tapAddButton() {
        viewModel.editingSubCard.value = SubCardModel()
        navigationController?.pushViewController(SubCardEditViewController(viewModel: viewModel),
                                                 animated: true)
        
    }
}

//MARK: - UICollectionDelegate

extension SubCardsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<Section,UUID> else { return }
        
        guard let id = dataSource.itemIdentifier(for: indexPath) else { return }
        
        navigationController?.pushViewController(SubCardEditViewController(viewModel: viewModel,
                                                                           selectedCardId: id),
                                                 animated: true)
    }
}

//MARK: - Configuration

extension SubCardsViewController {
    
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
}
