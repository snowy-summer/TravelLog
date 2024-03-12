//
//  StarRateView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit

final class StarRateView: UIView {
    
    private lazy var starScore = UILabel()
    private lazy var starStackView = UIStackView()
    private lazy var stars = [UIButton]()
    private lazy var starState = [Bool](repeating: false, count: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStarScoreLabel()
        configureStarStackView()
        configureStarImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StarRateView {
    
    private func configureStarScoreLabel() {
        self.addSubview(starScore)
        
        starScore.translatesAutoresizingMaskIntoConstraints = false
        
        starScore.text = "0 / 5"
        
        let scoreLabelConstraints = [
            starScore.topAnchor.constraint(equalTo: self.topAnchor,
                                           constant: 4),
            starScore.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                              constant: -4),
            starScore.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                               constant: 8),
            starScore.widthAnchor.constraint(equalTo: self.widthAnchor,
                                             multiplier: 0.1)
        ]
        
        NSLayoutConstraint.activate(scoreLabelConstraints)
    
    }
    
    private func configureStarStackView() {
        self.addSubview(starStackView)
        
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        
        starStackView.axis = .horizontal
        starStackView.distribution = .equalSpacing
        
        let stackConstraints = [
            starStackView.topAnchor.constraint(equalTo: self.topAnchor,
                                       constant: 4),
            starStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                          constant: -4),
            starStackView.leadingAnchor.constraint(equalTo: starScore.trailingAnchor),
            starStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(stackConstraints)
    
    }
    
    private func configureStarImage() {
        let starEmptyImage = UIImage(systemName: "star")
        
        for i in 0..<5 {
            let button = UIButton()
            button.setImage(starEmptyImage, for: .normal)
            button.tag = i
            stars.append(button)
            starStackView.addArrangedSubview(button)
            button.addTarget(self,
                             action: #selector(tapStar(sender: )),
                             for: .touchUpInside)
            button.widthAnchor.constraint(equalTo: button.heightAnchor,
                                          multiplier: 1.0).isActive = true
        }
    }
}


extension StarRateView {
    
    @objc private func tapStar(sender: UIButton) {
        let starEmptyImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        let end = sender.tag
        
        if starState[end] == false {
            starState[end] = !starState[end]
            for i in (end + 1)..<5 {
                starState[i] = !starState[end]
            }
            
            for i in 0...end {
                starState[i] = starState[end]
            }
        } else {
            for i in (end + 1)..<5 {
                starState[i] = !starState[end]
            }
            
            for i in 0...end {
                starState[i] = starState[end]
            }
            starState[end] = !starState[end]
        }
        
        for i in 0...4 {
            if starState[i] {
                stars[i].setImage(starFillImage, for: .normal)
            } else {
                stars[i].setImage(starEmptyImage, for: .normal)
            }
        }
    }
}
