//
//  SubCardListCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/28.
//

import UIKit
import SnapKit

final class SubCardListCell: UICollectionViewCell {
    
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
                      price: Double?,
                      currency: CurrencyList?,
                      starState: [Bool]) {
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        
        titleLabel.text = title ?? ""
        
        if let price = price,
           let formattedNumber = numberFormmater.string(from: NSNumber(value: price)),
           let currency = currency {
            priceLabel.text = "\(currency.symbol)" + formattedNumber
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
            guard let imageView = scoreImagesStackView.arrangedSubviews[i] as? UIImageView else { return }
            imageView.image = starState[i] ? UIImage(systemName: "star.fill") :  UIImage(systemName: "star")
        }
        
    }
}

//MARK: - Configuration

extension SubCardListCell {
    
    private func configureContentView() {
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.snp.verticalEdges).inset(8)
            make.directionalHorizontalEdges.equalTo(self.snp.directionalHorizontalEdges).inset(16)
        }
        
    }
    
    private func configureThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.layer.masksToBounds = true
        
        thumbnailImageView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.5)
            make.height.equalTo(contentView.snp.width).multipliedBy(0.5)
            
        }
        
        
    }
    private func configureScoreStackView() {
        contentView.addSubview(scoreImagesStackView)
        
        scoreImagesStackView.addArrangedSubview(firstStarImageView)
        scoreImagesStackView.addArrangedSubview(secondStarImageView)
        scoreImagesStackView.addArrangedSubview(thirdStarImageView)
        scoreImagesStackView.addArrangedSubview(fourthStarImageView)
        scoreImagesStackView.addArrangedSubview(fifthStarImageView)
        
        scoreImagesStackView.spacing = 4
        scoreImagesStackView.axis = .horizontal
        scoreImagesStackView.distribution = .fillEqually
        
        scoreImagesStackView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.top)
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.1)
        }
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreImagesStackView.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(thumbnailImageView.snp.leading).offset(16)
        }
        
    }
    
    private func configurePriceLabel() {
        contentView.addSubview(priceLabel)
        
        priceLabel.font = .preferredFont(forTextStyle: .body)
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(thumbnailImageView.snp.leading).offset(16)
        }
    }
    
}
