//
//  SubCardListCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/28.
//

import UIKit

final class SubCardListCell: UICollectionViewCell {
    
    static let identifier = "SubCardListCell"
    
    private var scoreImagesStackView = UIStackView()
   
    private let firstStarImageView = UIImageView()
    private let secondStarImageView = UIImageView()
    private let thirdStarImageView = UIImageView()
    private let fourthStarImageView = UIImageView()
    private let fifthStarImageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .defaultCell
        
        configureContentView()
        configureThumbnailImageView()
        configureScoreStackView()
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
                      price: Int?,
                      starState: [Bool]) {
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        
        titleLabel.text = title ?? ""
        
        if let price = price,
           let formattedNumber = numberFormmater.string(from: NSNumber(value: price)) {
            priceLabel.text = "₩ " + formattedNumber
        } else {
            priceLabel.text = ""
        }
        
        if let images = images,
            !images.isEmpty {
            thumbnailImageView.image = images[0]
        } else {
            thumbnailImageView.image = nil
        }
        
        for i in 0..<5 {
            let imageView = scoreImagesStackView.arrangedSubviews[i] as! UIImageView
            imageView.image = starState[i] ? UIImage(systemName: "star.fill") :  UIImage(systemName: "star")
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
        
        let thumbnailImageViewConstraints = [
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: 12),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                         constant: -8),
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                      multiplier: 0.5),
            thumbnailImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor,
                                                       multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(thumbnailImageViewConstraints)
        
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
    }
    private func configureScoreStackView() {
        contentView.addSubview(scoreImagesStackView)
        
        scoreImagesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scoreImagesStackView.addArrangedSubview(firstStarImageView)
        scoreImagesStackView.addArrangedSubview(secondStarImageView)
        scoreImagesStackView.addArrangedSubview(thirdStarImageView)
        scoreImagesStackView.addArrangedSubview(fourthStarImageView)
        scoreImagesStackView.addArrangedSubview(fifthStarImageView)
        
        scoreImagesStackView.spacing = 4
        scoreImagesStackView.axis = .horizontal
        scoreImagesStackView.distribution = .fillEqually
        
        let stackViewConstraints = [
            scoreImagesStackView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            scoreImagesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: 8),
            scoreImagesStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                         multiplier: 0.1)
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: scoreImagesStackView.bottomAnchor,
                                            constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor,
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
                                                constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor,
                                                 constant: 16)
        ]
        
        NSLayoutConstraint.activate(priceLabelConstraints)
    }

}
