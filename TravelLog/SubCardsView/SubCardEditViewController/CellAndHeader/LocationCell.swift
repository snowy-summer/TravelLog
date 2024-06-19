//
//  LocationView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit
import MapKit
import SnapKit

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
        
        locationImage.image = UIImage(systemName: "map")
        
        locationImage.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.trailing.equalToSuperview()
            make.width.equalTo(locationImage.snp.height)
        }
    }
    
    private func configureLocationText() {
        contentView.addSubview(locationText)
        
        locationText.textAlignment = .left
        locationText.placeholder = "위치를 선택하세요"
        locationText.font = .preferredFont(forTextStyle: .title3)
        locationText.isUserInteractionEnabled = false
        
        locationText.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview()
            make.trailing.equalTo(locationImage.snp.leading).inset(8)
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
