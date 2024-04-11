//
//  ScriptCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/08.
//

import UIKit

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
        
        scriptTextView.translatesAutoresizingMaskIntoConstraints = false
        scriptTextView.isUserInteractionEnabled = true
        
        scriptTextView.delegate = self
        scriptTextView.font = .preferredFont(forTextStyle: .body)
        scriptTextView.isScrollEnabled = false
        scriptTextView.isUserInteractionEnabled = true
        scriptTextView.backgroundColor = .viewBackground
        
        let viewConstraints = [
            scriptTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scriptTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scriptTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scriptTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scriptTextView.heightAnchor.constraint(greaterThanOrEqualTo: contentView.heightAnchor,
                                                   multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(viewConstraints)
    }
}

extension ScriptCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateViewModelValue(text: textView.text)
    }
}
