//
//  HeaderView.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/08.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTitle(text: String?) {
        titleLabel.text = text
    }
    
    private func configureTitle() {
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleConstraints = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(titleConstraints)
    }
}


