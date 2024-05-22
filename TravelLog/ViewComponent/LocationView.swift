//
//  LocationView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit
import MapKit

final class LocationView: UIView {
    
    private lazy var locationLabel = UILabel()
    private lazy var locationText = UITextField()
    private lazy var locationImage = UIImageView()
    private(set) var locationModel: LocationDTO?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLocationLabel()
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

extension LocationView {
    
    func updateLocationView(with location: LocationDTO?) {
        locationModel = location

        guard let mapitem = locationModel?.mapItem,
              let name = mapitem.name else { return }
        
        locationText.text = name
    }
    
    private func configureLocationLabel() {
        self.addSubview(locationLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationLabel.text = "위치"
        locationLabel.font = .preferredFont(forTextStyle: .callout)
        
        let labelConstraints = [
            locationLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            locationLabel.widthAnchor.constraint(equalTo: self.widthAnchor,
                                              multiplier: 0.1)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    private func configureLocationImage() {
        self.addSubview(locationImage)
        locationImage.translatesAutoresizingMaskIntoConstraints = false
        locationImage.image = UIImage(systemName: "location")
        
        let imageConstraints = [
            locationImage.topAnchor.constraint(equalTo: locationLabel.bottomAnchor,
                                            constant: 4),
            locationImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: -4),
            locationImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            locationImage.widthAnchor.constraint(equalTo: locationImage.heightAnchor,
                                              multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    private func configureLocationText() {
        self.addSubview(locationText)
        
        locationText.translatesAutoresizingMaskIntoConstraints = false
        
        locationText.textAlignment = .left
        locationText.placeholder = "위치를 선택하세요"
        locationText.font = .preferredFont(forTextStyle: .title3)
        locationText.isUserInteractionEnabled = false
        
        let textFieldConstraints = [
            locationText.topAnchor.constraint(equalTo: locationLabel.bottomAnchor,
                                                constant: 4),
            locationText.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                   constant: -4),
            locationText.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
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
