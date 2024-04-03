//
//  SubCardScrollView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/17.
//

import UIKit

final class SubCardScrollView: UIScrollView {

    private let viewModel: SubCardsViewModel
    private let selctedCardId: UUID?
    weak var subCardScrollViewDelegate: SubscrollViewDelegate?
    
    private(set) var contentView = UIView()
    private(set) var titleView = TitleView()
    private(set) var imageView = SelectedImageView()
    private(set) var starRateView = StarRateView()
    private(set) var priceView = PriceView()
    private(set) var locationView = LocationView()
    private(set) var categoryView = CategoryView()
    private(set) var scriptTextView = UITextView()
    
    init(viewModel: SubCardsViewModel, selctedCardId: UUID?) {
        self.viewModel = viewModel
        self.selctedCardId = selctedCardId
        super.init(frame: .zero)
        
        configureContentView()
        configureTitleView()
        configureImageView()
        configureStarsView()
        configurePriceView()
        configureLocationView()
        configureCategoryView()
        configureScriptView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SubCardScrollView {
    
    func updateContent(card: SubCardModelDTO) {
        titleView.updateText(card.title)
        starRateView.starState = card.starsState
        starRateView.updateButton()
        priceView.updatePrice(price: card.price)
        locationView.updateLocationView(with: card.location)
        categoryView.updateButton(category: card.category)
        scriptTextView.text = card.script
        
        if let cardImages = card.images,
            !cardImages.isEmpty {
            imageView.images = cardImages
            imageView.updateNumberOfPages(num: cardImages.count)
            imageView.updateImage(image: cardImages[0])
            imageView.isButtonHidden(value: true)
        } else {
            imageView.isButtonHidden(value: false)
        }
    }
    
    @objc private func pushMapViewController() {
        subCardScrollViewDelegate?.pushMapViewController()
    }
    
}

extension SubCardScrollView: TitleViewDelegate,
                             PriceViewDelegate,
                             SelectedImageViewDelegate,
                             StarRateViewDelegate,
                             CardCategoryViewDelegate {
    
    //MARK: - TitleViewDelegate
    
    func updateViewModelValue(title: String?) {
        viewModel.updateEditingCardTitle(title: title)
    }
    
    //MARK: - PriceViewDelegate
    
    func updateViewModelValue(price: String?) {
        viewModel.updateEditingCardPrice(price: price)
    }
    
    func presentCurrencyList() {
        let currencyList = UIAlertController(title: "통화 목록",
                                             message: nil,
                                             preferredStyle: .actionSheet)
        
        CurrencyList.allCases.forEach { currency in
            let action = UIAlertAction(title: currency.rawValue,
                                       style: .default) { action in
//TODO: - 통화 변경하고, 버튼 이름 변경, 기존의 통화 환전해서 변경
                

            }
            currencyList.addAction(action)
        }
        
        
        subCardScrollViewDelegate?.presentViewController(where: currencyList)
    }
    
    //MARK: - SelectedImageViewDelegate
    
    func updateViewModelValue(images: [UIImage]?) {
        viewModel.updateEditingCardImages(images: images)
    }
    
    
    func presentPicker(where viewController: UIViewController) {
        subCardScrollViewDelegate?.presentViewController(where: viewController)
    }
    
    //MARK: - StarRateViewDelegate
    
    func updateViewModelValue(starState: [Bool]) {
        viewModel.updateEditingCardStarState(starState: starState)
    }
    
    //MARK: - CardCategoryViewDelegate
    
    func updateViewModelCategory(category: CardCategory) {
        viewModel.updateEditingCardCategory(category: category)
    }
}

extension SubCardScrollView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateEditingCardScript(text: textView.text)
    }
}

//MARK: - Configuration

extension SubCardScrollView {
    
    private func configureContentView() {
        self.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(contentViewConstraints)
    }
    
    private func configureTitleView() {
        contentView.addSubview(titleView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.delegate = self
        titleView.layer.cornerRadius = 8
        titleView.backgroundColor = UIColor(resource: .viewBackground)
        
        let viewConstraints = [
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: 8),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            titleView.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor,
                                              multiplier: 0.1)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func configureImageView() {
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.delegate = self
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .viewBackground
        imageView.clipsToBounds = true
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: titleView.bottomAnchor,
                                           constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor,
                                              multiplier: 0.75)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configureStarsView() {
        contentView.addSubview(starRateView)
        
        starRateView.translatesAutoresizingMaskIntoConstraints = false
        
        starRateView.delegate = self
        starRateView.layer.cornerRadius = 8
        starRateView.backgroundColor = UIColor(resource: .viewBackground)
        
        let viewConstraints = [
            starRateView.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                              constant: 8),
            starRateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 16),
            starRateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -16),
            starRateView.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor,
                                                 multiplier: 0.05)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
        
    }
    
    private func configurePriceView() {
        contentView.addSubview(priceView)
        
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        priceView.delegate = self
        priceView.layer.cornerRadius = 8
        
        let viewConstraints = [
            priceView.topAnchor.constraint(equalTo: starRateView.bottomAnchor,
                                           constant: 8),
            priceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            priceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            priceView.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor,
                                              multiplier: 0.05)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func configureLocationView() {
        contentView.addSubview(locationView)
        
        locationView.translatesAutoresizingMaskIntoConstraints = false
        
        locationView.layer.cornerRadius = 8
        locationView.backgroundColor = .viewBackground
        locationView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                 action: #selector(pushMapViewController)))
        
        let viewConstraints = [
            locationView.topAnchor.constraint(equalTo: priceView.bottomAnchor,
                                              constant: 8),
            locationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 16),
            locationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -16),
            locationView.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor,
                                                 multiplier: 0.05)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func configureCategoryView() {
        contentView.addSubview(categoryView)
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        
        categoryView.layer.cornerRadius = 8
        categoryView.delegate = self
        
        let categoryViewConstraints = [
            categoryView.topAnchor.constraint(equalTo: locationView.bottomAnchor,
                                              constant: 8),
            categoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 16),
            categoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -16),
            categoryView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24)
        ]
        
        NSLayoutConstraint.activate(categoryViewConstraints)
    }
    
    private func configureScriptView() {
        contentView.addSubview(scriptTextView)
        
        scriptTextView.translatesAutoresizingMaskIntoConstraints = false
        
        scriptTextView.delegate = self
        scriptTextView.font = .preferredFont(forTextStyle: .body)
        scriptTextView.isScrollEnabled = false
        scriptTextView.layer.cornerRadius = 8
        scriptTextView.backgroundColor = .viewBackground
        
        let viewConstraints = [
            scriptTextView.topAnchor.constraint(equalTo: categoryView.bottomAnchor,
                                                constant: 8),
            scriptTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: 16),
            scriptTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -16),
            scriptTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scriptTextView.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor,
                                                   multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
}
