//
//  HeaderView.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/08.
//

import UIKit
import SnapKit

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
        
        titleLabel.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
}


