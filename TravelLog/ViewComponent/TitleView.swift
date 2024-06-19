//
//  TitleView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit
import SnapKit

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
        
        titleTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.directionalHorizontalEdges.equalToSuperview().inset(8)
        }
        
    }
    
}
