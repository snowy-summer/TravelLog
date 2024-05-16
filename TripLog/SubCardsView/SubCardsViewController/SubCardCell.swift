//
//  SubCardCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class SubCardCell: UICollectionViewCell {
    
    static let identifier = "SubCardCell"
    
    private lazy var titleView = TitleView()
    private lazy var thumbnailImageView = UIImageView()
    private lazy var starRateView = StarRateView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .defaultCell
        
        configureTitleView()
        configureThumbnailImageView()
        configureStarsRateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .defaultCell
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let circularLayoutAttributes = layoutAttributes as? CircularLayoutAttributes else { return }
        self.layer.anchorPoint = circularLayoutAttributes.anchorPoint
        self.center.y += (circularLayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
    }
    
}

//MARK: - Method

extension SubCardCell {
    
    func updateContent(title: String?,
                       images: [UIImage]?,
                       starState: [Bool]){
        
        titleView.updateText(title)
        starRateView.starState = starState
        starRateView.updateButton()
        
        if let images = images, 
            !images.isEmpty {
            thumbnailImageView.image = images[0]
        } else {
            thumbnailImageView.backgroundColor = UIColor(resource: .viewBackground)
        }
    }
}


//MARK: - Configuration

extension SubCardCell {
    
    private func configureTitleView() {
        contentView.addSubview(titleView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.isUserInteractionEnabled = false
        titleView.layer.cornerRadius = 8
        titleView.backgroundColor = UIColor(resource: .viewBackground)
        
        let titleViewConstraints = [
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: 16),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            titleView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor,
                                               multiplier: 0.25)
        ]
        
        NSLayoutConstraint.activate(titleViewConstraints)
        
    }
    
    private func configureThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.layer.masksToBounds = true
        
        let imageViewConstraints = [
            thumbnailImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor,
                                                   constant: 8),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: 16),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -16),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor,
                                                       multiplier: 1.0),
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configureStarsRateView() {
        contentView.addSubview(starRateView)
        
        starRateView.translatesAutoresizingMaskIntoConstraints = false
        
        starRateView.layer.cornerRadius = 8
        starRateView.backgroundColor = .viewBackground
        starRateView.isUserInteractionEnabled = false
        
       let viewConstraint = [
        starRateView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor,
                                          constant: 8),
        starRateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: 16),
        starRateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -16),
        starRateView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.075)
       ]
        
        NSLayoutConstraint.activate(viewConstraint)
    }
    
    
}
