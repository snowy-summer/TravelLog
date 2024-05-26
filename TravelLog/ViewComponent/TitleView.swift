//
//  TitleView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit

protocol TitleViewDelegate: AnyObject {
    
    func updateViewModelValue(title: String?)
    
}

final class TitleView: UIView {
    
    weak var delegate: TitleViewDelegate?
    
    private lazy var titleTextField = UITextField()
    
    var text: String? {
        guard let title = titleTextField.text else { return nil }
        return title
    }
    
    override init(frame: CGRect) {
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
        titleTextField.text = text
    }
    
    @objc func didTextFieldChange() {
        delegate?.updateViewModelValue(title: titleTextField.text)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
}

//MARK: - Configuration

extension TitleView {
    
    private func configureTitleTextField() {
        self.addSubview(titleTextField)
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.placeholder = "제목"
        titleTextField.font = .preferredFont(forTextStyle: .title1)
        titleTextField.textColor = .black
        titleTextField.autocorrectionType = .no
        titleTextField.spellCheckingType = .no
        
        titleTextField.addTarget(self,
                                 action: #selector(didTextFieldChange),
                                 for: .editingChanged)
        titleTextField.addTarget(self,
                                 action: #selector(dismissKeyboard),
                                 for: .editingDidEndOnExit)
        
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
