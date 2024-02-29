//
//  MainCardCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

final class MainCardCell: UICollectionViewCell {
    
    static let identifier = "MainCardCell"
    
    private lazy var titleLabel = UILabel()
    private lazy var sumbnailImageView = UIImageView()
    private lazy var dateLabel = UILabel()
    private lazy var moreButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSumbnailImageView()
        configureTitlLabel()
        configureDateLabel()
        configureMoreButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainCardCell {
    
    private func configureSumbnailImageView() {
        contentView.addSubview(sumbnailImageView)
        sumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewConstraints = [
            sumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            sumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configureTitlLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.text = "제목"
        
        let titleLabelConstraints = [
            titleLabel.bottomAnchor.constraint(equalTo: sumbnailImageView.bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        
    }
    
    private func configureDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "2023.02.28"
        
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: sumbnailImageView.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(dateLabelConstraints)
        
    }
    
    private func configureMoreButton() {
        contentView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        let moreButtonConstraints = [
            moreButton.topAnchor.constraint(equalTo: sumbnailImageView.bottomAnchor),
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(moreButtonConstraints)
    }
}
