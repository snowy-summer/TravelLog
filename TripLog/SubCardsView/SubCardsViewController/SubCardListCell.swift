//
//  SubCardListCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/28.
//

import UIKit

final class SubCardListCell: UICollectionViewCell {
    
    static let identifier = "SubCardListCell"
    
    private let scoreImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .defaultCell
        
        configureContentView()
        configureThumbnailImageView()
        configureScoreImageView()
        configureTitleLabel()
        configurePriceLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Method

extension SubCardListCell {
    
    func updateCotent(images: [UIImage]?,
                      title: String?,
                      price: Int?) {
        
        titleLabel.text = title
        
        if let price = price {
            priceLabel.text = String(price)
        }
        
        if let images = images,
            !images.isEmpty {
            thumbnailImageView.image = images[0]
        } else {
            thumbnailImageView.backgroundColor = UIColor(resource: .viewBackground)
        }
    }
}

//MARK: - Configuration

extension SubCardListCell {
    
    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
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
        
    }
    
    private func configureThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
        
        let thumbnailImageViewConstraints = [
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: 8),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                         constant: -8),
            thumbnailImageView.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor,
                                                      multiplier: 0.4),
            thumbnailImageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor,
                                                      multiplier: 0.5),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor,
                                                       multiplier: 3/4),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                       constant: -8),
        ]
        
        NSLayoutConstraint.activate(thumbnailImageViewConstraints)
    }
    
    private func configureScoreImageView() {
        contentView.addSubview(scoreImageView)
        
        scoreImageView.translatesAutoresizingMaskIntoConstraints = false
        
        scoreImageView.image = UIImage(resource: .airport)
        
        let scoreImageViewConstraints = [
            scoreImageView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            scoreImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: 16),
            scoreImageView.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor,
                                                   multiplier: 0.2),
            scoreImageView.widthAnchor.constraint(equalTo: scoreImageView.heightAnchor,
                                                  multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(scoreImageViewConstraints)
        
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: scoreImageView.bottomAnchor,
                                            constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: 16)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        
    }
    
    private func configurePriceLabel() {
        contentView.addSubview(priceLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.font = .preferredFont(forTextStyle: .caption2)
    
        let priceLabelConstraints = [
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                            constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: 16)
        ]
        
        NSLayoutConstraint.activate(priceLabelConstraints)
    }

}
