//
//  SubCardEditView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/11.
//

import UIKit

final class SubCardEditViewController: UIViewController {
    
    private let viewModel: SubCardsViewModel
    private let mainQueue = DispatchQueue.main
    private var selctedCardId: UUID?
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var titleView = TitleView()
    private lazy var imageView = SelectedImageView()
    private lazy var starRateView = StarRateView()
    private lazy var priceView = PriceView()
    private lazy var locationView = LocationView()
    private lazy var scriptTextView = UITextView()
    
    init(viewModel: SubCardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(viewModel: SubCardsViewModel, selectedCardId: UUID) {
        self.init(viewModel: viewModel)
        self.selctedCardId = selectedCardId
        
        loadSubCard(selectedCardId: selectedCardId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        
        configureNavigationBar()
        
        configureScrollView()
        configureContentView()
        configureTitleView()
        configureImageView()
        configureStarsView()
        configurePriceView()
        configureLocationView()
        configureScriptView()
    }
}

//MARK: - Method

extension SubCardEditViewController {
    
    private func loadSubCard(selectedCardId: UUID) {
        let index = viewModel.list.value.firstIndex { subCard in
            subCard.id == selectedCardId
        }
        guard let index = index else { return }
        
        let card = viewModel.list.value[index]
        
        titleView.updateText(card.title)
        
        if let cardImages = card.images,
            !cardImages.isEmpty {
            imageView.images = cardImages
            imageView.updateNumberOfPages(num: cardImages.count)
            imageView.updateImage(image: cardImages[0])
            imageView.isButtonHidden(value: true)
        } else {
            imageView.isButtonHidden(value: false)
        }
        
        starRateView.starState = card.starsState
        starRateView.updateButton()
        priceView.updatePrice(price: card.money)
        scriptTextView.text = card.script
       
    }
    
    private func addGesture(action: Selector, where view: UIView) {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: action)
        view.addGestureRecognizer(gesture)
    }
}

//MARK: - objc

extension SubCardEditViewController {
    
    @objc private func doneAction() {
        
        if let cardId = selctedCardId {
            
            viewModel.updateContent(selectedCardId: cardId,
                                    title: titleView.text,
                                    images: imageView.images,
                                    starsState: starRateView.starState,
                                    price: priceView.price,
                                    script: scriptTextView.text)
            
        } else {
            
            viewModel.appendSubCard(title: titleView.text,
                                    images: imageView.images,
                                    starsState: starRateView.starState,
                                    price: priceView.price,
                                    script: scriptTextView.text)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func touchLocationView() {
     
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
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
    }
    
    private func configureContentView() {
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(contentViewConstraints)
    }
    
    private func configureTitleView() {
        contentView.addSubview(titleView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.layer.cornerRadius = 8
        titleView.layer.borderWidth = 1
        titleView.backgroundColor = .viewBackground
        
        let viewConstraints = [
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: 16),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            titleView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,
                                              multiplier: 0.1)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func configureImageView() {
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .viewBackground
        imageView.delegate = self
        imageView.clipsToBounds = true
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: titleView.bottomAnchor,
                                           constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor,
                                              multiplier: 0.3),
            imageView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,
                                              multiplier: 0.25)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configureStarsView() {
        contentView.addSubview(starRateView)
        
        starRateView.translatesAutoresizingMaskIntoConstraints = false
        starRateView.layer.cornerRadius = 8
        starRateView.layer.borderWidth = 1
        starRateView.backgroundColor = .viewBackground
        
        let viewConstraints = [
            starRateView.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                              constant: 16),
            starRateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 16),
            starRateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -16),
            starRateView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,
                                                 multiplier: 0.05)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
        
    }
    
    private func configurePriceView() {
        contentView.addSubview(priceView)
        
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        priceView.backgroundColor = .viewBackground
        priceView.layer.cornerRadius = 8
        priceView.layer.borderWidth = 1
        
        let viewConstraints = [
            priceView.topAnchor.constraint(equalTo: starRateView.bottomAnchor,
                                           constant: 16),
            priceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            priceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            priceView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,
                                              multiplier: 0.05)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func configureLocationView() {
        contentView.addSubview(locationView)
        
        locationView.translatesAutoresizingMaskIntoConstraints = false
        
        locationView.layer.cornerRadius = 8
        locationView.layer.borderWidth = 1
        locationView.backgroundColor = .viewBackground
        
        let viewConstraints = [
            locationView.topAnchor.constraint(equalTo: priceView.bottomAnchor,
                                              constant: 16),
            locationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 16),
            locationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -16),
            locationView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,
                                                 multiplier: 0.05)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func configureScriptView() {
        contentView.addSubview(scriptTextView)
        
        scriptTextView.translatesAutoresizingMaskIntoConstraints = false
        
        scriptTextView.font = .preferredFont(forTextStyle: .body)
        scriptTextView.isScrollEnabled = false
        scriptTextView.layer.cornerRadius = 8
        scriptTextView.layer.borderWidth = 1
        scriptTextView.backgroundColor = .viewBackground
        
        let viewConstraints = [
            scriptTextView.topAnchor.constraint(equalTo: locationView.bottomAnchor,
                                                constant: 16),
            scriptTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: 16),
            scriptTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -16),
            scriptTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scriptTextView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
}

extension SubCardEditViewController: SelectedImageViewDelegate {
    
    func presentViewController(where viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
    
}
