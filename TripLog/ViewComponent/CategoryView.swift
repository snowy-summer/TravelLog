//
//  CategoryView.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/01.
//

import UIKit

protocol CardCategoryViewDelegate: AnyObject {
    
    func updateViewModelCategory(category: CardCategory)
    
}

final class CategoryView: UIView {
    
    private let stackView = UIStackView()
    
    private var buttons = [UIButton]()
    
    weak var delegate: CardCategoryViewDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateButton(category: CardCategory?) {
        guard let category = category else { return }
        buttons.forEach { button in
            if let title = button.title(for: .normal),
               let buttonCategory = CardCategory(rawValue: title) {
                button.configuration?.baseBackgroundColor = buttonCategory == category ? .white : .viewBackground
            }
        }
    }
    
    private func configureStackView() {
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        let stackConstraints = [
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(stackConstraints)
        
        CardCategory.allCases.forEach { category in
            let button = UIButton()
            
            configureButton(button: button,
                            category: category)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func configureButton(button: UIButton,
                                 category: CardCategory) {
        stackView.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonConfiguration = buttonConfiguration()

        button.configuration = buttonConfiguration
    
        button.configuration?.baseBackgroundColor = .viewBackground
        button.setTitle(category.rawValue,
                        for: .normal)
        button.setTitleColor(.black,
                             for: .normal)
        button.setImage(category.image,
                        for: .normal)
        
        button.addTarget(self,
                         action: #selector(tapButton),
                         for: .touchUpInside)
        
    }
    
    @objc func tapButton(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text,
              let category = CardCategory(rawValue: text) else { return }
        
        delegate?.updateViewModelCategory(category: category)
        
        buttons.forEach { button in
            button.configuration?.baseBackgroundColor = .viewBackground
        }
        
        sender.configuration?.baseBackgroundColor = .white
        
    }
    
    private func buttonConfiguration() -> UIButton.Configuration {
        
        var configuration = UIButton.Configuration.bordered()
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4
        configuration.cornerStyle = .capsule
        
        return configuration
    }
    
}
