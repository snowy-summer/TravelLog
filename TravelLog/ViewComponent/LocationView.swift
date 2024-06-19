//
//  LocationView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit
import MapKit
import SnapKit

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
        
        locationLabel.text = "위치"
        locationLabel.font = .preferredFont(forTextStyle: .callout)
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    private func configureLocationImage() {
        self.addSubview(locationImage)
        
        locationImage.image = UIImage(systemName: "location")
        
        locationImage.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.trailing.equalToSuperview()
            make.width.equalTo(locationImage.snp.height)
        }
    }
    
    private func configureLocationText() {
        self.addSubview(locationText)
        
        locationText.textAlignment = .left
        locationText.placeholder = "위치를 선택하세요"
        locationText.font = .preferredFont(forTextStyle: .title3)
        locationText.isUserInteractionEnabled = false
        
        locationText.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalTo(locationLabel.snp.leading)
            make.trailing.equalTo(locationImage.snp.leading).offset(-8)
        }
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
