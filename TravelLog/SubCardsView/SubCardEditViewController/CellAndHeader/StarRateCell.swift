//
//  StarRateCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/08.
//

import UIKit

final class StarRateCell: UICollectionViewCell {
    
    weak var delegate: StarRateViewDelegate?
    
    private var starStackView = UIStackView()
    private var stars = [UIButton]()
    var starState = [Bool](repeating: false, count: 5)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(starStackView)
        
        configureStarImage()
        configureStarStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStarStackView() {
        contentView.addSubview(starStackView)
        
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        
        starStackView.axis = .horizontal
        starStackView.distribution = .fillEqually
        starStackView.spacing = 4
        
        let stackConstraints = [
            starStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 4),
            starStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -4),
            starStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(stackConstraints)
        
    }
    
    private func configureStarImage() {
        let starEmptyImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        
        for i in 0..<5 {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = i
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            stars.append(button)
            starStackView.addArrangedSubview(button)
            
            button.heightAnchor.constraint(equalTo: self.heightAnchor,
                                           multiplier: 1.0,
                                           constant: -8).isActive = true
            button.widthAnchor.constraint(equalTo: button.heightAnchor,
                                          multiplier: 1.0).isActive = true

            button.addTarget(self,
                             action: #selector(tapStar),
                             for: .touchUpInside)
            
            if starState[i] {
                button.setImage(starFillImage, for: .normal)
            } else {
                button.setImage(starEmptyImage, for: .normal)
            }
        }
    }
    
    @objc private func tapStar(_ sender: UIButton) {
        let starEmptyImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        let end = sender.tag
        let filledCount = starState.filter { $0 == true }.count
        
        if starState[end] == false {
            starState[end] = true

        } else if starState[end] && filledCount == end + 1{
            starState[end] = !starState[end]
        }
        
        for i in (end + 1)..<5 {
            starState[i] = false
        }
        
        for i in 0..<end {
            starState[i] = true
        }
        
        for i in 0...4 {
            if starState[i] {
                stars[i].setImage(starFillImage, for: .normal)
            } else {
                stars[i].setImage(starEmptyImage, for: .normal)
            }
        }
        
        delegate?.updateViewModelValue(starState: starState)
    }
    
    func updateButton() {
        let starEmptyImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        for i in 0...4 {
            if starState[i] {
                stars[i].setImage(starFillImage, for: .normal)
            } else {
                stars[i].setImage(starEmptyImage, for: .normal)
            }
        }
    }
}
