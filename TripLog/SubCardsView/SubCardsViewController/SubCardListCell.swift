//
//  SubCardListCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/28.
//

import UIKit

final class SubCardListCell: UICollectionViewCell {
    
    static let identifier = "SubCardListCell"
    
    private let informationStackView = UIStackView()
    private let scoreImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureThumbnailImageView()
        configureStackView()
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
    
    func updateCotent(image: UIImage?,
                      title: String?,
                      price: String?) {
        
        thumbnailImageView.image = image
        titleLabel.text = title
        priceLabel.text = price
    }
}

//MARK: - Configuration

extension SubCardListCell {
    
    private func configureThumbnailImageView() {
        self.addSubview(thumbnailImageView)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailImageView.layer.cornerRadius = 8
        
        let thumbnailImageViewConstraints = [
            thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor,
                                                    constant: 8),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                       constant: -8),
            thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                         constant: -8),
            thumbnailImageView.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                      multiplier: 0.3),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor,
                                                       multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(thumbnailImageViewConstraints)
    }
    
    private func configureStackView() {
        self.addSubview(informationStackView)
        
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        informationStackView.alignment = .leading
        
        let stackViewConstraints = [
            informationStackView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            informationStackView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            informationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                          constant: 8),
            informationStackView.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor,
                                                           constant: -16),
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
    }
    
    private func configureScoreImageView() {
        informationStackView.addArrangedSubview(scoreImageView)
        
        let scoreImageViewConstraints = [
            scoreImageView.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                  multiplier: 1/15),
            scoreImageView.heightAnchor.constraint(equalTo: scoreImageView.widthAnchor,
                                                   multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(scoreImageViewConstraints)
        
    }
    
    private func configureTitleLabel() {
        informationStackView.addArrangedSubview(titleLabel)
        
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        
    }
    
    private func configurePriceLabel() {
        informationStackView.addArrangedSubview(priceLabel)
        
        priceLabel.font = .preferredFont(forTextStyle: .body)
    
    }
}
