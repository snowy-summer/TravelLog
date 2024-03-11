//
//  SubCardEditView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/11.
//

import UIKit


final class SubCardEditView: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var contentView = UIView()
    
    private var titleTextField = UITextField()
    private var titleView = UIView()
    
    private var imageView = UIImageView()
    
    private var starsView = UIView()
    private var priceView = UIView()
    private var mapView = UIView()
    
    private var scriptView = UIView()
    private var scriptTextView = UITextView()
    
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        configureScrollView()
        configureContentView()
        configureTitleView()
        configureTitle()
        configureImageView()
        configureStarsView()
        configureMapView()
        configurePriceView()
        configureScriptView()
        configureScript()
    }
}

extension SubCardEditView {
    
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
    
    private func configureTitle() {
        titleView.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.font = .preferredFont(forTextStyle: .title1)
        titleTextField.textAlignment = .center
        titleTextField.placeholder = "제목"
        
        let titleConstraints = [
            titleTextField.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleTextField.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(titleConstraints)
        
    }
    
    private func configureImageView() {
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.image = UIImage(resource: .addImagePlaceHolder)
        imageView.clipsToBounds = true
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: titleView.bottomAnchor,
                                           constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            imageView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,
                                             multiplier: 0.25),
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
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
    
    private func configureMapView() {
        contentView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 8
        mapView.layer.borderWidth = 1

        let viewConstraints = [
            mapView.topAnchor.constraint(equalTo: starsView.bottomAnchor,
                                           constant: 16),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: 16),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                           constant: -16),
            mapView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,
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
            priceView.topAnchor.constraint(equalTo: mapView.bottomAnchor,
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
    
    private func configureScriptView() {
        contentView.addSubview(scriptView)
        scriptView.translatesAutoresizingMaskIntoConstraints = false
        scriptView.layer.cornerRadius = 8
        scriptView.layer.borderWidth = 1

        let viewConstraints = [
            scriptView.topAnchor.constraint(equalTo: priceView.bottomAnchor,
                                            constant: 16),
            scriptView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: 16),
            scriptView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -16),
            scriptView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scriptView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func configureScript() {
        scriptView.addSubview(scriptTextView)
        scriptTextView.translatesAutoresizingMaskIntoConstraints = false
        scriptTextView.font = .preferredFont(forTextStyle: .body)
        scriptTextView.isScrollEnabled = false
        
        let scriptConstraints = [
            scriptTextView.topAnchor.constraint(equalTo: scriptView.topAnchor,
                                                 constant: 8),
            scriptTextView.leadingAnchor.constraint(equalTo: scriptView.leadingAnchor,
                                                     constant: 8),
            scriptTextView.trailingAnchor.constraint(equalTo: scriptView.trailingAnchor,
                                                      constant: -8),
            scriptTextView.bottomAnchor.constraint(equalTo: scriptView.bottomAnchor,
                                                    constant: -8)
        ]
        
        NSLayoutConstraint.activate(scriptConstraints)
    }
    
}
