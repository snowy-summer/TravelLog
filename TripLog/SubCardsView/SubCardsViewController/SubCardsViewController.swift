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
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    private var addButton = UIButton()
    private var deleteButton = UIButton()
    private var cancelButton = UIButton()
    
    private var selectingModeState: Bool {
        didSet {
            isSelectingModeOn(state: selectingModeState)
        }
    }
    
    init(mainCardId: UUID,
         delegate: SubCardsViewControllerDelegate? = nil,
         subcards: [SubCardModelDTO]) {
        
        self.mainCardId = mainCardId
        self.delegate = delegate
        self.viewModel.list.value = subcards
        self.selectingModeState = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .basic
        
        collectionView.delegate = self
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
        bind()
        configureAddButton()
        configureDeleteButton()
        configureCancelButton()
        isSelectingModeOn(state: selectingModeState)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
}

extension SubCardsViewController {
    
    private func bind() {
        viewModel.list.observe { [weak self] subCards in
            guard let self = self else { return }
            saveSnapshot(id: subCards.map { $0.id } )
            delegate?.changeSubCards(mainCardId: mainCardId, card: subCards)
        }
    }
    
    private func changeCollectionViewLayout() {
        if collectionView.collectionViewLayout is CircularLayout {
            collectionView.collectionViewLayout = createBasicCompositionalLayout()
        } else {
            let bound = collectionView.bounds
            print(bound)
            
            collectionView.collectionViewLayout = CircularLayout(itemSize: CGSize(width: bound.width * 0.8,
                                                                                  height: bound.height * 0.6),
                                                                 
                                                                 radius: bound.height)
        }
    }
    
    private func createBasicCompositionalLayout() -> UICollectionViewCompositionalLayout{
        var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        
        layoutConfiguration.backgroundColor = .basic
        layoutConfiguration.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
        
        return layout
    }
    
    private func isSelectingModeOn(state: Bool) {
        addButton.isHidden = state
        deleteButton.isHidden = !state
        cancelButton.isHidden = !state
        
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            for indexPath in selectedItems {
                collectionView.deselectItem(at: indexPath, animated: false)
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.contentView.backgroundColor = .defaultCell
            }
        }
    }
    
    @objc private func tapAddButton() {
        viewModel.editingSubCard.value = SubCardModelDTO()
        navigationController?.pushViewController(SubCardEditViewController(viewModel: viewModel),
                                                 animated: true)
    }
    
    @objc private func tapDeleteButton() {
        var uuidsToDelete = Set<UUID>()
        guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<Section,UUID> else { return }
        
        
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            
            for indexPath in selectedItems {
                guard let id = dataSource.itemIdentifier(for: indexPath) else { return }
                uuidsToDelete.insert(id)
                
                selectingModeState = false
            }
        }
        
        viewModel.deleteSubCard(uuidsToDelete: uuidsToDelete)
    }
    
    @objc private func tapCancelButton() {
        selectingModeState = false
    }
    
}

//MARK: - UICollectionViewDelegate

extension SubCardsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<Section,UUID> else { return }
        
        guard let id = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if selectingModeState, let cell = collectionView.cellForItem(at: indexPath)  {
            cell.contentView.backgroundColor = .black
            
        } else {
            navigationController?.pushViewController(SubCardEditViewController(viewModel: viewModel,
                                                                               selectedCardId: id),
                                                     animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        
        if selectingModeState, let cell = collectionView.cellForItem(at: indexPath)  {
            cell.contentView.backgroundColor = .defaultCell
            
        }
    }
}

extension SubCardsViewController: SubCardsCollectionViewDelegate {
    
    func saveSnapshot(id: [UUID]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(id,toSection: .main)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func configureDataSource() {
        let cardCellRegistration = UICollectionView.CellRegistration<SubCardCell, UUID> { [weak self] cell, indexPath, itemIdentifier in
            guard let self = self else { return }
            let tupleArray = self.viewModel.list.value.map {($0.id, $0)}
            let subCardDictionary: [UUID: SubCardModelDTO] = Dictionary(uniqueKeysWithValues: tupleArray)
            
            guard let subCard = subCardDictionary[itemIdentifier] else { return }
            
            cell.updateContent(title: subCard.title,
                               images: subCard.images,
                               starState: subCard.starsState)
            
        }
        
        let listCellRegistration = UICollectionView.CellRegistration<SubCardListCell, UUID> {
            [weak self] cell, indexPath, itemIdentifier in
            
            guard let self = self else { return }
            
            let tupleArray = self.viewModel.list.value.map {($0.id, $0)}
            let subCardDictionary: [UUID: SubCardModelDTO] = Dictionary(uniqueKeysWithValues: tupleArray)
            
            guard let subCard = subCardDictionary[itemIdentifier] else { return }
            
            cell.updateCotent(images: subCard.images,
                              title: subCard.title,
                              price: subCard.price,
                              currency: subCard.currency,
                              starState: subCard.starsState)
            
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, UUID>(collectionView: collectionView,
                                                                               cellProvider: {
            collectionView, indexPath, uuid in
            
            if collectionView.collectionViewLayout is CircularLayout {
                
                return collectionView.dequeueConfiguredReusableCell(using: cardCellRegistration,
                                                                    for: indexPath,
                                                                    item: uuid)
            } else {
                
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration,
                                                                    for: indexPath,
                                                                    item: uuid)
            }
        })
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
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = createBasicCompositionalLayout()
        
        let safeArea = view.safeAreaLayoutGuide
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureBarButtonMenu(button: UIBarButtonItem) {
        
        let changeLayout = UIAction(title: "보기 변경",
                                    image: UIImage(systemName: "square.grid.2x2.fill")) { [weak self] action in
            
            guard let self = self else { return }
            changeCollectionViewLayout()
            
        }
        
        let select = UIAction(title: "선택",
                              image: UIImage(systemName: "checkmark.circle")  ) { [weak self] action in
            
            guard let self = self else { return }
            selectingModeState = true
            collectionView.allowsMultipleSelection = true
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
    
    private func configureDeleteButton() {
        view.addSubview(deleteButton)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.setImage(UIImage(resource: .deleteButton),
                              for: .normal)
        deleteButton.contentVerticalAlignment = .fill
        deleteButton.contentHorizontalAlignment = .fill
        deleteButton.addTarget(self,
                               action: #selector(tapDeleteButton),
                               for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        let addButtonConstraints = [
            deleteButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                 constant: -view.bounds.height * 0.01),
            deleteButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor),
            deleteButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                multiplier: 0.2),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(addButtonConstraints)
        
    }
    
    private func configureCancelButton() {
        view.addSubview(cancelButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.setImage(UIImage(resource: .cancelButton),
                              for: .normal)
        cancelButton.contentVerticalAlignment = .fill
        cancelButton.contentHorizontalAlignment = .fill
        cancelButton.addTarget(self,
                               action: #selector(tapCancelButton),
                               for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        let addButtonConstraints = [
            cancelButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                 constant: -view.bounds.height * 0.01),
            cancelButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                multiplier: 0.2),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor),
            
        ]
        
        NSLayoutConstraint.activate(addButtonConstraints)
        
    }
}
