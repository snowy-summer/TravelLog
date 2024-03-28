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
    private lazy var scriptTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .defaultCell
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        
        configureTitleView()
        configureThumbnailImageView()
        configureStarsRateView()
        configureScript()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.backgroundColor = .defaultCell
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
                       starState: [Bool],
                       script: String?) {
        
        titleView.updateText(title)
        scriptTextView.text = script
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
        
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
        
        let imageViewConstraints = [
            thumbnailImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor,
                                                   constant: 8),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: 16),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -16),
            thumbnailImageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor,
                                                      multiplier: 0.4)
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
    
    private func configureScript() {
        contentView.addSubview(scriptTextView)
        
        scriptTextView.translatesAutoresizingMaskIntoConstraints = false
        
        scriptTextView.layer.cornerRadius = 8
        
        scriptTextView.font = .preferredFont(forTextStyle: .title1)
        scriptTextView.backgroundColor = .viewBackground
        scriptTextView.isUserInteractionEnabled = false
        
        let imageViewConstraints = [
            scriptTextView.topAnchor.constraint(equalTo: starRateView.bottomAnchor,
                                                constant: 8),
            scriptTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: 16),
            scriptTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -16),
            scriptTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -16)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
}
