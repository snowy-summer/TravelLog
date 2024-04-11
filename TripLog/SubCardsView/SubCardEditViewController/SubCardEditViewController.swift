//
//  SubCardEditViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/05.
//

import UIKit

final class SubCardEditViewController: UIViewController {
    
    private let viewModel: SubCardsViewModel
    private var selectedCardId: UUID?
    private var diffableDataSource: UICollectionViewDiffableDataSource<SubCardSection, ContentsOfCell>?
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: createLayout())
    
    init(viewModel: SubCardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configureDataSource()
        saveSnapshot(card: viewModel.editingSubCard.value)
    }
    
    convenience init(viewModel: SubCardsViewModel,
                     selectedCardId: UUID) {
        self.init(viewModel: viewModel)
        self.selectedCardId = selectedCardId
        
        loadSubCard(selectedCardId: selectedCardId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        
        bind()
        configureNavigationBar()
        configureCollectionView()
    }
}

//MARK: - Method

extension SubCardEditViewController {
    
    private func loadSubCard(selectedCardId: UUID) {
        guard let card = viewModel.selectCard(id: selectedCardId) else { return }
        
        viewModel.editingSubCard.value = card
        viewModel.title.value = card.title
        viewModel.price.value = card.price
        viewModel.starsState.value = card.starsState
        viewModel.location.value = card.location
        viewModel.category.value = card.category
    }
    
    private func bind() {
        viewModel.editingSubCard.observe{ [weak self] subCard in
            guard let self = self else { return }
            saveSnapshot(card: subCard)
        }
    }
    
    private func saveSnapshot(card: SubCardModelDTO) {
        var snapshot = NSDiffableDataSourceSnapshot<SubCardSection, ContentsOfCell>()
        
        snapshot.appendSections([SubCardSection.title,
                                 SubCardSection.image,
                                 SubCardSection.starRate,
                                 SubCardSection.price,
                                 SubCardSection.location,
                                 SubCardSection.category,
                                 SubCardSection.script])
        
        var titleItem: ContentsOfCell
        var images: [ContentsOfCell]
        var starsState: ContentsOfCell
        var price: ContentsOfCell
        var location: ContentsOfCell
        var category: ContentsOfCell
        var script: ContentsOfCell
        
        titleItem = card.title != nil ? .title(card.title) : .title("")
        images = card.images != nil ? card.images!.map{ContentsOfCell.images($0)}: []
        images.append(ContentsOfCell.images(UIImage()))
        starsState = ContentsOfCell.starsState(card.starsState)
        price = card.price != nil ? .price(card.price) : .price(0)
        location = card.location != nil ? .location(card.location) : .location(LocationDTO())
        category = card.category != nil ? .category(card.category) : .category(CardCategory.transportation)
        script = card.script != nil ? .script(card.script) : .script("")
        
        snapshot.appendItems([titleItem],toSection: SubCardSection.title)
        snapshot.appendItems(images,toSection: SubCardSection.image)
        snapshot.appendItems([starsState], toSection: SubCardSection.starRate)
        snapshot.appendItems([price], toSection: SubCardSection.price)
        snapshot.appendItems([location], toSection: SubCardSection.location)
        snapshot.appendItems([category], toSection: SubCardSection.category)
        snapshot.appendItems([script], toSection: SubCardSection.script)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            diffableDataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
}

//MARK: - objc

extension SubCardEditViewController {
    
    @objc private func doneAction() {
        viewModel.updateEditingSubCard()
        viewModel.clearToProperty()
        if let cardId = selectedCardId {
            viewModel.updateSubCard(id: cardId,
                                    card: viewModel.editingSubCard.value)
        } else {
            viewModel.list.value.append(viewModel.editingSubCard.value)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backAction() {
        viewModel.clearToProperty()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pushMapViewController() {
        viewModel.updateEditingSubCard()
        self.navigationController?.pushViewController(MapViewController(delegate: self,
                                                                        location: viewModel.editingSubCard.value.location),
                                                      animated: true)
    }
}

//MARK: - MapViewControllerDelegate

extension SubCardEditViewController: MapViewControllerDelegate {
    
    func updateLocation(location: LocationDTO) {
        viewModel.location.value = location
        viewModel.updateEditingSubCard()
    }
    
}

extension SubCardEditViewController: TitleViewDelegate,
                                     SelectedImageViewDelegate,
                                     StarRateViewDelegate,
                                     PriceViewDelegate,
                                     CardCategoryViewDelegate,
                                     ScriptCellDelegate {
    
    //MARK: - TitleViewDelegate
    
    func updateViewModelValue(title: String?) {
        viewModel.title.value = title
    }
    
    //MARK: - SelectedImageViewDelegate
    
    func updateViewModelValue(images: [UIImage]?) {
        viewModel.updateEditingCardImages(images: images)
    }
    
    
    func presentPicker(who viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
    
    //MARK: - StarRateViewDelegate
    
    func updateViewModelValue(starState: [Bool]) {
        viewModel.starsState.value = starState
    }
    
    //MARK: - PriceViewDelegate
    
    func updateViewModelValue(price: String?) {
        viewModel.updatePrice(value: price)
    }
    
    func presentCurrencyList() {
        let currencyList = UIAlertController(title: "통화 목록",
                                             message: nil,
                                             preferredStyle: .actionSheet)
        let userDefaults = UserDefaults.standard
        let currencyConveter = CurrencyConverter()
        
        CurrencyList.allCases.forEach { currency in
            let currencyName = currency.rawValue
            
            let list = UIAlertAction(title: currencyName,
                                     style: .default) { [weak self] action in
                
                guard let self = self else { return }
                guard var price = viewModel.price.value,
                      let rate = currencyConveter.calculateCurrencyRate(currency: currency) else { return }
                userDefaults.set(currencyName,
                                 forKey: "currentCurrency")
                
                price /= rate
                viewModel.price.value = price
                viewModel.updateEditingSubCard()
                
            }
            
            currencyList.addAction(list)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel)
        currencyList.addAction(cancelAction)
        
        self.present(currencyList, animated: true)
    }
    
    //MARK: - CardCategoryViewDelegate
    
    func updateViewModelValue(category: CardCategory) {
        viewModel.category.value = category
    }
    
    //MARK: - ScriptCellDelegate
    
    func updateViewModelValue(text: String?) {
        viewModel.script.value = text
    }
    
}

//MARK: - Configuration

extension SubCardEditViewController {
    
    private func configureNavigationBar() {
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .plain,
                                         target: self,
                                         action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneButton
        
        
        let backButton = UIBarButtonItem(title: "뒤로가기",
                                         style: .plain,
                                         target: self,
                                         action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let sectionType = SubCardSection(rawValue: sectionIndex)
            
            return sectionType?.layoutSection
        }
    }
    
    private func configureDataSource() {
        
        let titleCellRegistration = UICollectionView.CellRegistration<TitleCell, String?> { cell, indexPath, item in
            
            cell.delegate = self
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 16
            cell.updateText(item)
        }
        
        let imageCellRegistration = UICollectionView.CellRegistration<ImageCell, UIImage> { cell, indexPath, item in
            
            cell.delegate = self
            cell.layer.cornerRadius = 20
            cell.layer.masksToBounds = true
            cell.isUserInteractionEnabled = true
            cell.updateImage(item)
        }
        
        let starRateCellRegistration = UICollectionView.CellRegistration<StarRateCell, [Bool]> {  cell, indexPath, item in
            
            cell.delegate = self
            cell.isUserInteractionEnabled = true
            cell.starState = item
            cell.updateButton()
        }
        
        let priceCellRegistration = UICollectionView.CellRegistration<PriceCell, Double?> {  cell, indexPath, item in
            
            cell.delegate = self
            cell.updatePrice(price: item)
            cell.updateButtonTitle(text: UserDefaults.standard.object(forKey: "currentCurrency") as? String)
        }
        
        let locationCellRegistration = UICollectionView.CellRegistration<LocationCell, LocationDTO> {  [weak self]  cell, indexPath, item in
            
            guard let self = self else { return }
            
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(pushMapViewController)))
            cell.updateLocationView(with: item)
        }
        
        let categoryCellRegistration = UICollectionView.CellRegistration<CategoryCell, CardCategory> { cell, indexPath, item in
            
            cell.delegate = self
            cell.isUserInteractionEnabled = true
            cell.updateButton(category: item)
        }
        
        let scriptCellRegistration = UICollectionView.CellRegistration<ScriptCell, String?> {  cell, indexPath, item in
            
            cell.delegate = self
            cell.isUserInteractionEnabled = true
            cell.layer.cornerRadius = 20
            cell.layer.borderWidth = 1
            cell.layer.masksToBounds = true
            cell.updateScriptTextView(text: item)
        }
        
        let headerRegisteration = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, elementKind, indexPath in
            
        }
        
        
        diffableDataSource = UICollectionViewDiffableDataSource<SubCardSection, ContentsOfCell>(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch item {
            case .title(let text):
                return collectionView.dequeueConfiguredReusableCell(using: titleCellRegistration,
                                                                    for: indexPath,
                                                                    item: text)
                
            case .images(let images):
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration,
                                                                    for: indexPath,
                                                                    item: images)
                
            case .starsState(let state):
                return collectionView.dequeueConfiguredReusableCell(using: starRateCellRegistration,
                                                                    for: indexPath,
                                                                    item: state)
                
            case .price(let price):
                return collectionView.dequeueConfiguredReusableCell(using: priceCellRegistration,
                                                                    for: indexPath,
                                                                    item: price)
            case .location(let location):
                return collectionView.dequeueConfiguredReusableCell(using: locationCellRegistration,
                                                                    for: indexPath,
                                                                    item: location)
            case .category(let category):
                return collectionView.dequeueConfiguredReusableCell(using: categoryCellRegistration,
                                                                    for: indexPath,
                                                                    item: category)
            case .script(let text):
                return collectionView.dequeueConfiguredReusableCell(using: scriptCellRegistration,
                                                                    for: indexPath,
                                                                    item: text)
            default:
                return nil
            }
        }
        
        diffableDataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            
            let section = SubCardSection(rawValue: indexPath.section)
            let header = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegisteration,
                                                                               for: indexPath)
            switch section {
            case .price:
                header.updateTitle(text: section?.title)
                return header
                
            case .location:
                header.updateTitle(text: section?.title)
                return header
                
            case .category:
                header.updateTitle(text: section?.title)
                return header
                
            case .script:
                header.updateTitle(text: section?.title)
                return header
                
            default:
                return nil
            }
            
        }
    }
}
