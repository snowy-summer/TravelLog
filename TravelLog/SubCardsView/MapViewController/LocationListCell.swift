//
//  LocationCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/15.
//

import UIKit
import SnapKit

final class LocationListCell: UICollectionViewCell {
    
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var icon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureIcon()
        configureTitle()
        configureSubTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        icon.image = nil
    }
    
}

//MARK: - Configuration

extension LocationListCell {
    
    private func configureIcon() {
        contentView.addSubview(icon)
        
        icon.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(8)
            make.height.lessThanOrEqualTo(40)
            make.width.equalTo(icon.snp.height)
        }
    }
    
    private func configureTitle() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(icon.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(icon.snp.height).multipliedBy(0.4)
        }
    }
    
    private func configureSubTitle() {
        contentView.addSubview(subTitleLabel)
        
        subTitleLabel.font = .systemFont(ofSize: 12)
        subTitleLabel.textColor = .lightGray
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.directionalHorizontalEdges.equalTo(titleLabel.snp.directionalHorizontalEdges)
            make.height.lessThanOrEqualTo(titleLabel.snp.height)
        }
    }
    
    func updateContent(title: String?,
                       subtitle: String?,
                       iconImage: UIImage?) {
        
        titleLabel.text = title
        subTitleLabel.text = subtitle
        icon.image = iconImage
    }
    
    func highlightedText(text: String,
                         ranges: [NSValue],
                         size: CGFloat) {
        
        let attributedText = NSMutableAttributedString(string: text)
        let normalFont = UIFont.systemFont(ofSize: size)
        
        attributedText.addAttribute(.font,
                                    value: normalFont,
                                    range: NSRange(location: 0,
                                                   length: text.count))
        
        for range in ranges {
            let boldFont = UIFont.boldSystemFont(ofSize: size)
            
            let nsRange = range.rangeValue
            attributedText.addAttribute(.font,
                                        value: boldFont,
                                        range: nsRange)
        }
        
        titleLabel.attributedText = attributedText
    }
}
