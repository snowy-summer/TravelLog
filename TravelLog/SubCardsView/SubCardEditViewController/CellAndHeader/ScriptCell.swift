//
//  ScriptCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/08.
//

import UIKit
import SnapKit

protocol ScriptCellDelegate: AnyObject {
    
    func updateViewModelValue(text: String?)
}

final class ScriptCell: UICollectionViewCell {
    
    private let scriptTextView = UITextView()
    weak var delegate: ScriptCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureScriptView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScriptTextView(text: String?) {
        scriptTextView.text = text
    }
    
    private func configureScriptView() {
        contentView.addSubview(scriptTextView)
        
        scriptTextView.isUserInteractionEnabled = true
        
        scriptTextView.delegate = self
        scriptTextView.font = .preferredFont(forTextStyle: .body)
        scriptTextView.isScrollEnabled = false
        scriptTextView.isUserInteractionEnabled = true
        scriptTextView.backgroundColor = .viewBackground
        
        scriptTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(contentView.snp.height).multipliedBy(0.5)
        }
    }
}

extension ScriptCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateViewModelValue(text: textView.text)
    }
}
