//
//  SubCardsViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/06.
//

import UIKit
import SnapKit

final class SubCardsViewController: UIViewController {
    
    private let mainCardId: UUID
    private let viewModel = SubCardsViewModel()
    weak var delegate: SubCardsViewControllerDelegate?
    
    private lazy var collectionView = SubCardsCollectionView(viewModel: viewModel,
                                                             size: view.bounds.size)
    private lazy var addButton = UIButton()
    private lazy var deleteButton = UIButton()
    private lazy var cancelButton = UIButton()
    
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
        collectionView.configureAutoLayout(superView: view)
        configureNavigationBar()
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
            self.collectionView.saveSnapshot(id: subCards.map { $0.id } )
            self.delegate?.changeSubCards(mainCardId: mainCardId, card: subCards)
        }
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
            cell.contentView.backgroundColor = #colorLiteral(red: 0.7607458234, green: 0.6978967786, blue: 1, alpha: 1)
            
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
        
        let changeLayout = UIAction(title: "보기 변경",
                                    image: UIImage(systemName: "square.grid.2x2.fill")) { [weak self] action in
            
            guard let self = self else { return }
            collectionView.changeLayout()
            
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
        
        addButton.setImage(UIImage(resource: .plusButton), for: .normal)
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.addTarget(self,
                            action: #selector(tapAddButton),
                            for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).offset(-view.bounds.height * 0.01)
            make.width.equalTo(view.snp.width).multipliedBy(0.2)
            make.height.equalTo(addButton.snp.width)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    private func configureDeleteButton() {
        view.addSubview(deleteButton)
        
        deleteButton.setImage(UIImage(resource: .deleteButton),
                              for: .normal)
        deleteButton.contentVerticalAlignment = .fill
        deleteButton.contentHorizontalAlignment = .fill
        deleteButton.addTarget(self,
                               action: #selector(tapDeleteButton),
                               for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).offset(-view.bounds.height * 0.01)
            make.trailing.equalTo(addButton.snp.leading)
            make.width.equalTo(view.snp.width).multipliedBy(0.2)
            make.height.equalTo(deleteButton.snp.width)
        }
    }
    
    private func configureCancelButton() {
        view.addSubview(cancelButton)
        
        cancelButton.setImage(UIImage(resource: .cancelButton),
                              for: .normal)
        cancelButton.contentVerticalAlignment = .fill
        cancelButton.contentHorizontalAlignment = .fill
        cancelButton.addTarget(self,
                               action: #selector(tapCancelButton),
                               for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).offset(-view.bounds.height * 0.01)
            make.leading.equalTo(addButton.snp.trailing)
            make.width.equalTo(view.snp.width).multipliedBy(0.2)
            make.height.equalTo(cancelButton.snp.width)
        }
    }
}
