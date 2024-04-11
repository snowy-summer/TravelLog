//
//  TitleCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/05.
//

import UIKit

final class TitleCell: UICollectionViewCell {
    
    weak var delegate: TitleViewDelegate?
    private var titleTextField = UITextField()
   
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureTitleTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Method

extension TitleCell {
    
    func updateText(_ item: String?) {
        titleTextField.text = item
//        switch item {
//        case .title(let text):
//            DispatchQueue.main.async { [weak self] in
//                
//                self?.titleTextField.text = text
//            }
//        default:
//            break
//        }
    }
    
    @objc func didTextFieldChange() {
            delegate?.updateViewModelValue(title: titleTextField.text)
    }
    
}

//MARK: - Configuration

extension TitleCell {
    
    private func configureTitleTextField() {
        contentView.addSubview(titleTextField)
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.placeholder = "제목"
        titleTextField.font = .preferredFont(forTextStyle: .title1)
        titleTextField.textColor = .black
        titleTextField.autocorrectionType = .no
        titleTextField.spellCheckingType = .no
        
        titleTextField.addTarget(self,
                                 action: #selector(didTextFieldChange),
                                 for: .editingChanged)
        
        let titleTextFieldConstraints = [
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: 4),
            titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -4),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -8),
        ]
        
        NSLayoutConstraint.activate(titleTextFieldConstraints)
        
    }
    
}
