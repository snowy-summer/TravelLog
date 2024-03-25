//
//  TitleView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit

final class TitleView: UIView {
    
    private lazy var titleTextField = UITextField()
    private let viewModel: SubCardsViewModel?
    
    var text: String? {
        guard let title = titleTextField.text else { return nil }
        return title
    }
    
    init(viewModel: SubCardsViewModel?) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureTitleTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Method

extension TitleView {
    
    func updateText(_ text: String?) {
        titleTextField.placeholder = nil
        titleTextField.text = text
    }
    
}

//MARK: - Configuration

extension TitleView {
    
    private func configureTitleTextField() {
        self.addSubview(titleTextField)
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.delegate = self
        titleTextField.placeholder = "제목"
        titleTextField.font = .preferredFont(forTextStyle: .title1)
        titleTextField.textColor = .black
        titleTextField.autocorrectionType = .no
        titleTextField.spellCheckingType = .no
        
        let titleTextFieldConstraints = [
            titleTextField.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: 4),
            titleTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                constant: -4),
            titleTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                     constant: -8),
        ]
        
        NSLayoutConstraint.activate(titleTextFieldConstraints)
        
    }
    
}

extension TitleView: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard let viewModel = viewModel else { return true }
        
        viewModel.updateEditingCardTitle(title: textField.text)
        
        return true
    }
}
