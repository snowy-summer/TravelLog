//
//  SubCardCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit

final class SubCardCell: UICollectionViewCell {
    
    static let identifier = "SubCardCell"
    
    private lazy var titleView = TitleView(viewModel: nil)
    private lazy var sumbnailImageView = UIImageView()
    private lazy var starRateView = StarRateView()
    private lazy var scriptTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 0.6251164079, green: 0.8091775775, blue: 1, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        
        configureTitleView()
        configureSumbnailImageView()
        configureStarsRateView()
        configureScript()
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
            sumbnailImageView.image = images[0]
        } else {
            sumbnailImageView.backgroundColor = .viewBackground
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
    
    private func configureSumbnailImageView() {
        contentView.addSubview(sumbnailImageView)
        
        sumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        sumbnailImageView.layer.cornerRadius = 8
        sumbnailImageView.clipsToBounds = true
        
        let imageViewConstraints = [
            sumbnailImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor,
                                                   constant: 8),
            sumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: 16),
            sumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -16),
            sumbnailImageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor,
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
        starRateView.topAnchor.constraint(equalTo: sumbnailImageView.bottomAnchor,
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
