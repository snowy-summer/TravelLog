//
//  CategoryView.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/01.
//

import UIKit
import SnapKit

protocol CardCategoryViewDelegate: AnyObject {
    
    func updateViewModelValue(category: CardCategory)
    
}

final class CategoryView: UIView {
    
    private let categoryTitleLabel = UILabel()
    private let stackView = UIStackView()
    
    private var buttons = [UIButton]()
    
    weak var delegate: CardCategoryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCategoryLabel()
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
    
    private func configureCategoryLabel() {
        self.addSubview(categoryTitleLabel)
        
        categoryTitleLabel.text = "테마"
        
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    private func configureStackView() {
        self.addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
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
        
        let buttonConfiguration = buttonConfiguration()
        
        button.configuration = buttonConfiguration
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
        
        buttons.forEach { button in
            button.configuration?.baseBackgroundColor = .viewBackground
        }
        
        sender.configuration?.baseBackgroundColor = .white
        
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
