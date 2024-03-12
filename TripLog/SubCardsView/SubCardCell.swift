//
//  SubCardCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class SubCardCell: UICollectionViewCell {
    
    static let identifier = "SubCardCell"
    
    private lazy var titleLabel = UILabel()
    private lazy var titleView = UIView()
    private lazy var sumbnailImageView = UIImageView()
    private lazy var stars = UIImageView()
    private lazy var script = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSumbnailImageView()
        configureTitleView()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let circularLayoutAttributes = layoutAttributes as? CircularLayoutAttributes else { return }
        self.layer.anchorPoint = circularLayoutAttributes.anchorPoint
        self.center.y += (circularLayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
    }
    
}

extension SubCardCell {
    
    private func configureSumbnailImageView() {
        contentView.addSubview(sumbnailImageView)
        sumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        sumbnailImageView.image = UIImage(resource: .addImagePlaceHolder)
        
        let imageViewConstraints = [
            sumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                   constant: 16),
            sumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: 16),
            sumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -16),
            sumbnailImageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor,
                                                      multiplier: 0.4)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configureTitleView() {
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleViewConstraints = [
            titleView.topAnchor.constraint(equalTo: sumbnailImageView.bottomAnchor,
                                           constant: 16),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            titleView.heightAnchor.constraint(lessThanOrEqualTo: sumbnailImageView.heightAnchor,
                                               multiplier: 0.3)
        ]
        
        NSLayoutConstraint.activate(titleViewConstraints)
        
        titleView.layer.cornerRadius = 8
        titleView.layer.borderWidth = 1
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textAlignment = .center
        titleLabel.text = "美味"
        
        let imageViewConstraints = [
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    } 
    
    private func configureScript() {
        contentView.addSubview(script)
        script.translatesAutoresizingMaskIntoConstraints = false
        script.font = .preferredFont(forTextStyle: .title1)
        script.textAlignment = .center
        script.text = "美味"
        
        let imageViewConstraints = [
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    
    
}
