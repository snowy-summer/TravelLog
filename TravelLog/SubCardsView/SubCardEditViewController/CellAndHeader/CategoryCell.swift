//
//  CategoryCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/08.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    
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
        
        for button in buttons {
            if let title = button.attributedTitle(for: .normal),
               let buttonCategory = CardCategory(rawValue: title.string) {
                button.configuration?.baseBackgroundColor = buttonCategory == category ? .lightGray : .viewBackground
            }
        }
    }
    
    private func configureStackView() {
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        let stackConstraints = [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(stackConstraints)
        
        CardCategory.allCases.forEach { category in
            let button = UIButton()

            let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
            let attributedTitle = NSAttributedString(string: category.rawValue,
                                                     attributes: attribute)
            button.setAttributedTitle(attributedTitle, for: .normal)
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
        delegate?.updateViewModelValue(category: category)
        
        for button in buttons {
            if sender == button {
                sender.configuration?.baseBackgroundColor = .lightGray
                continue
            }
            button.configuration?.baseBackgroundColor = .viewBackground
        }
    }
    
    private func buttonConfiguration() -> UIButton.Configuration {
        
        var configuration = UIButton.Configuration.bordered()
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
        configuration.imagePlacement = .top
        configuration.imagePadding = 4
        configuration.cornerStyle = .capsule
        
        return configuration
    }
    
}
