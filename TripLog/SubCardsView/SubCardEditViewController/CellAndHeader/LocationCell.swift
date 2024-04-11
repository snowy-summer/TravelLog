//
//  LocationView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit
import MapKit

final class LocationCell: UICollectionViewCell {
    
    private lazy var locationText = UITextField()
    private lazy var locationImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLocationImage()
        configureLocationText()
        
        DispatchQueue.main.async {
            self.configureUnderLine(size: 2,
                               color: UIColor.lightGray.cgColor)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LocationCell {
    
    func updateLocationView(with location: LocationDTO?) {

        guard let mapitem = location?.mapItem,
              let name = mapitem.name else { return }
        
        locationText.text = name
    }
    
    private func configureLocationImage() {
        contentView.addSubview(locationImage)
        locationImage.translatesAutoresizingMaskIntoConstraints = false
        locationImage.image = UIImage(systemName: "map")
        
        let imageConstraints = [
            locationImage.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: 8),
            locationImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -8),
            locationImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            locationImage.widthAnchor.constraint(equalTo: locationImage.heightAnchor,
                                              multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    private func configureLocationText() {
        contentView.addSubview(locationText)
        
        locationText.translatesAutoresizingMaskIntoConstraints = false
        
        locationText.textAlignment = .left
        locationText.placeholder = "위치를 선택하세요"
        locationText.font = .preferredFont(forTextStyle: .title3)
        locationText.isUserInteractionEnabled = false
        
        let textFieldConstraints = [
            locationText.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: 4),
            locationText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -4),
            locationText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationText.trailingAnchor.constraint(equalTo: locationImage.leadingAnchor,
                                                     constant: -8)
        ]
        
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
    private func configureUnderLine(size: CGFloat, color: CGColor?) {
        let underLine = CALayer()
        self.layer.addSublayer(underLine)
        underLine.backgroundColor = color
        
        underLine.frame = CGRect(origin: CGPoint(x: locationText.frame.origin.x,
                                                 y: self.frame.height),
                                 size: CGSize(width: locationText.frame.width,
                                              height: size))
        
    }
    
}
