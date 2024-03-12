//
//  LocationView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit

final class LocationView: UIView {
    
    private lazy var locationLabel = UILabel()
    private lazy var locationTextField = UITextField()
    private lazy var locationImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLocationLabel()
        configureLocationImage()
        configureLocationTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LocationView {
    
    private func configureLocationLabel() {
        self.addSubview(locationLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationLabel.text = "위치"
        
        let labelConstraints = [
            locationLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: 4),
            locationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: -4),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 8),
            locationLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor,
                                              multiplier: 0.1)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    private func configureLocationImage() {
        self.addSubview(locationImage)
        locationImage.translatesAutoresizingMaskIntoConstraints = false
        locationImage.image = UIImage(systemName: "location.fill")
        
        let imageConstraints = [
            locationImage.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: 4),
            locationImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: -4),
            locationImage.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -4),
            locationImage.widthAnchor.constraint(equalTo: locationImage.heightAnchor,
                                              multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    private func configureLocationTextField() {
        self.addSubview(locationTextField)
        
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        
        locationTextField.textAlignment = .left
        
        let textFieldConstraints = [
            locationTextField.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: 4),
            locationTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                   constant: -4),
            locationTextField.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor,
                                                    constant: 8),
            locationTextField.trailingAnchor.constraint(equalTo: locationImage.leadingAnchor,
                                                     constant: -8)
        ]
        
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
}
