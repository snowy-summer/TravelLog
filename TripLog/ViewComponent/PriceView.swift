//
//  PriceView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit

protocol PriceViewDelegate: AnyObject {
    
    func updateViewModelValue(price: String?)
    
}

final class PriceView: UIView {
    
    private lazy var priceLabel = UILabel()
    private lazy var priceTextField = UITextField()
    private lazy var priceImage = UIImageView()
    
    weak var delegate: PriceViewDelegate?
    
    var price: Int {
        guard let price = Int(priceTextField.text!) else { return 0 }
        return price
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurePriceLabel()
        configurePriceImage()
        configurePriceTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Method

extension PriceView {
    
    func updatePrice(price: Int?) {
        guard let price = price else { return }
        
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        let formattedNumber = numberFormmater.string(from: NSNumber(value: price))
        
        priceTextField.text = formattedNumber
    }
    
    @objc func didTextFieldChange() {
        let text = priceTextField.text?.split(separator: ",").joined()
        delegate?.updateViewModelValue(price: text)
    }
}

//MARK: - Configuration

extension PriceView {
    
    private func configurePriceLabel() {
        self.addSubview(priceLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.text = "가격"
        
        let labelConstraints = [
            priceLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: 4),
            priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: -4),
            priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 8),
            priceLabel.widthAnchor.constraint(equalTo: self.widthAnchor,
                                              multiplier: 0.1)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    private func configurePriceImage() {
        self.addSubview(priceImage)
        
        priceImage.translatesAutoresizingMaskIntoConstraints = false
        
        priceImage.image = UIImage(systemName: "wonsign.circle")
        
        let imageConstraints = [
            priceImage.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: 4),
            priceImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: -4),
            priceImage.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -4),
            priceImage.widthAnchor.constraint(equalTo: priceImage.heightAnchor,
                                              multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    private func configurePriceTextField() {
        self.addSubview(priceTextField)
        
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        priceTextField.textAlignment = .right
        priceTextField.addTarget(self,
                                 action: #selector(didTextFieldChange),
                                 for: .editingChanged)
        
        let textFieldConstraints = [
            priceTextField.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: 4),
            priceTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                   constant: -4),
            priceTextField.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor,
                                                    constant: 8),
            priceTextField.trailingAnchor.constraint(equalTo: priceImage.leadingAnchor,
                                                     constant: -8)
        ]
        
        NSLayoutConstraint.activate(textFieldConstraints)
    }
}
