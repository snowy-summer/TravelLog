//
//  LocationCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/15.
//

import UIKit


final class LocationListCell: UICollectionViewCell {
    
    static let identifier = "LocationListCell"
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var icon = UIImageView()
    

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
    
    
    
    private func configureIcon() {
        contentView.addSubview(icon)
        
        icon.translatesAutoresizingMaskIntoConstraints = false

        let iconConstraints = [
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                          constant: 8),
            icon.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.05),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor,
                                        multiplier: 1.0),
        ]
        
        NSLayoutConstraint.activate(iconConstraints)
    }
    
    private func configureTitle() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleConstraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor,
                                           constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(titleConstraints)
    }
    
    private func configureSubTitle() {
        contentView.addSubview(subTitleLabel)
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.font = .systemFont(ofSize: 12)
        subTitleLabel.textColor = .lightGray
        
        let titleConstraints = [
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                          constant: 8),
            subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -8),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
           
        ]
        
        NSLayoutConstraint.activate(titleConstraints)
    }
    
    func updateContent(title: String?, subtitle: String?, iconImage: UIImage?) {
        
        titleLabel.text = title
        subTitleLabel.text = subtitle
        icon.image = iconImage
    }
}
