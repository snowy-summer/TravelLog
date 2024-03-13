//
//  SubCardEditView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/11.
//

import UIKit
import PhotosUI

final class SubCardEditViewController: UIViewController {
    
    private let viewModel: SubCardsViewModel
    private let mainQueue = DispatchQueue.main
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var titleView = TitleView()
    private lazy var imageView = UIImageView()
    private lazy var addButton = UIButton()
    private lazy var starsView = StarRateView()
    private lazy var priceView = PriceView()
    private lazy var locationView = LocationView()
    private lazy var scriptTextView = UITextView()
    
    init(viewModel: SubCardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        configureAddButton()
        configureStarsView()
        configurePriceView()
        configureLocationView()
        configureScriptView()
    }
}

extension SubCardEditViewController {
    
    @objc private func doneAction() {
        
        let subCard = SubCard(title: titleView.text,
                              starsState: starsView.starState,
                              money: 0,
                              images: [imageView.image],
                              script: scriptTextView.text)
        
        viewModel.list.value.append(subCard)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
}

//MARK: - PHPickerViewControllerDelegate

extension SubCardEditViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                self?.mainQueue.async {
                    self?.imageView.image = image as? UIImage
                }
            }
        }
        
        if imageView.image == nil  && results.isEmpty {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
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
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(addImage)))
        
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
    
    private func configureAddButton() {
        imageView.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.setImage(UIImage(resource: .plusButton), for: .normal)
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.addTarget(self,
                            action: #selector(addImage),
                            for: .touchUpInside)
        
        let addButtonConstraints = [
            addButton.widthAnchor.constraint(equalTo: imageView.widthAnchor,
                                             multiplier: 0.2),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            addButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(addButtonConstraints)
    }
    
    private func configureStarsView() {
        contentView.addSubview(starsView)
        
        starsView.translatesAutoresizingMaskIntoConstraints = false
        starsView.layer.cornerRadius = 8
        starsView.layer.borderWidth = 1
        
        let viewConstraints = [
            starsView.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                           constant: 16),
            starsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            starsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            starsView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,
                                              multiplier: 0.08)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
        
    }
    
    private func configurePriceView() {
        contentView.addSubview(priceView)
        
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        priceView.layer.cornerRadius = 8
        priceView.layer.borderWidth = 1
        
        let viewConstraints = [
            priceView.topAnchor.constraint(equalTo: starsView.bottomAnchor,
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
