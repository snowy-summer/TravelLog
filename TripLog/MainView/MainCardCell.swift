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
    
    private lazy var backView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureContentView()
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
    
    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.borderWidth = 1
        
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: self.topAnchor,
                                             constant: 8),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                constant: -8),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: 16),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -16)
        ]
        
        NSLayoutConstraint.activate(contentViewConstraints)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    private func configureSumbnailImageView() {
        contentView.addSubview(sumbnailImageView)
        sumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        sumbnailImageView.image = UIImage(resource: .testMain)
        
        sumbnailImageView.contentMode = .scaleToFill
        let imageViewConstraints = [
            sumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            sumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sumbnailImageView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.25)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configureTitlLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .white
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
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant:  -8)
        ]
        
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
    
    private func configureMoreButton() {
        contentView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.addTarget(self,
                             action: #selector(tapMoreButton),
                             for: .touchUpInside)
        
        let moreButtonConstraints = [
            moreButton.topAnchor.constraint(equalTo: sumbnailImageView.bottomAnchor),
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -16),
            moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -8)
        ]
        
        NSLayoutConstraint.activate(moreButtonConstraints)
    }
    
    @objc private func tapMoreButton() {
        
    }
}
