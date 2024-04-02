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
            if let title = button.titleLabel?.text,
               let buttonCategory = CardCategory(rawValue: title) {
                button.backgroundColor = buttonCategory == category ? buttonCategory.color : .baseOfCell
            }
        }
    }
    
    private func configureStackView() {
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        let stackConstraints = [
            stackView.topAnchor.constraint(equalTo: self.topAnchor,
                                               constant: 16),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                              constant: -16),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                               constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -16)
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
        
        button.layer.cornerRadius = 8

        button.setTitle(category.rawValue,
                        for: .normal)
        button.setTitleColor(.black,
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
            button.backgroundColor = .baseOfCell
        }
        
        sender.backgroundColor = category.color
    }
}
