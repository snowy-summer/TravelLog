//
//  TitleView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit

final class TitleView: UIView {
    
    private lazy var titleTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTitleTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TitleView {
    
    private func configureTitleTextField() {
        
        self.addSubview(titleTextField)
        titleTextField.placeholder = "제목"
        titleTextField.font = .preferredFont(forTextStyle: .title1)
        titleTextField.textColor = .black
        titleTextField.autocorrectionType = .no
        titleTextField.spellCheckingType = .no
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
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
    
//    private func configureTitle() {
//        titleView.addSubview(titleTextField)
//        titleTextField.translatesAutoresizingMaskIntoConstraints = false
//        titleTextField.font = .preferredFont(forTextStyle: .title1)
//        titleTextField.textAlignment = .center
//        titleTextField.placeholder = "제목"
//        
//        let titleConstraints = [
//            titleTextField.topAnchor.constraint(equalTo: titleView.topAnchor),
//            titleTextField.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
//            titleTextField.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
//            titleTextField.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
//        ]
//        
//        NSLayoutConstraint.activate(titleConstraints)
//        
//    }
}
