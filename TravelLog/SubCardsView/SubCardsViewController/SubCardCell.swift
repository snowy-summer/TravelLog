//
//  SubCardCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/07.
//

import UIKit
import SnapKit

final class SubCardCell: UICollectionViewCell {
    
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
        
        titleView.isUserInteractionEnabled = false
        titleView.layer.cornerRadius = 8
        titleView.backgroundColor = UIColor(resource: .viewBackground)
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
            make.height.lessThanOrEqualTo(contentView.snp.height).multipliedBy(0.25)
        }
        
    }
    
    private func configureThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.layer.masksToBounds = true
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.75)
        }
        
    }
    
    private func configureStarsRateView() {
        contentView.addSubview(starRateView)
        
        starRateView.layer.cornerRadius = 8
        starRateView.backgroundColor = .viewBackground
        starRateView.isUserInteractionEnabled = false
        
        starRateView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
            make.height.equalTo(self.snp.height).multipliedBy(0.075)
        }
    }
    
    
}
