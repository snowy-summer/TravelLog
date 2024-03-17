//
//  LocationCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/15.
//

import UIKit


final class LocationListCell: UICollectionViewCell {
    
    static let identifier = "LocationListCell"
    
    var title = UILabel()
    var subTitle = UILabel()
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
    
    private func configureIcon() {
        contentView.addSubview(icon)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "star")
        let iconConstraints = [
            icon.topAnchor.constraint(equalTo: self.topAnchor),
            icon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor,
                                        multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(iconConstraints)
    }
    
    private func configureTitle() {
        contentView.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let titleConstraints = [
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor,
                                           constant: 16),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(titleConstraints)
    }
    
    private func configureSubTitle() {
        contentView.addSubview(subTitle)
        
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let titleConstraints = [
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor),
            subTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            subTitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            subTitle.trailingAnchor.constraint(equalTo: title.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(titleConstraints)
    }
    
}
