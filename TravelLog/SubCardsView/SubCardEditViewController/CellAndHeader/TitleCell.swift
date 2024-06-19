//
//  TitleCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/05.
//

import UIKit
import SnapKit

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
    }
    
    @objc func didTextFieldChange() {
        delegate?.updateViewModelValue(title: titleTextField.text)
    }
    
}

//MARK: - Configuration

extension TitleCell {
    
    private func configureTitleTextField() {
        contentView.addSubview(titleTextField)
        
        titleTextField.placeholder = "제목"
        titleTextField.font = .preferredFont(forTextStyle: .title1)
        titleTextField.textColor = .black
        titleTextField.autocorrectionType = .no
        titleTextField.spellCheckingType = .no
        
        titleTextField.addTarget(self,
                                 action: #selector(didTextFieldChange),
                                 for: .editingChanged)
        
        titleTextField.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(4)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
        }
        
    }
    
}
