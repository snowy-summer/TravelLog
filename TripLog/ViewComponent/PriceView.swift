//
//  PriceView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit

protocol PriceViewDelegate: AnyObject {
    
    func updateViewModelValue(price: String?)
    func presentCurrencyList()
    
}

final class PriceView: UIView {
    
    private lazy var priceLabel = UILabel()
    private lazy var priceTextField = UITextField()
    private lazy var swapCurrencyButton = UIButton()
    
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
        DispatchQueue.main.async {
            self.configureUnderLine(size: 2,
                               color: UIColor.lightGray.cgColor)
        }
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
    
    @objc func swapCurrency() {
        delegate?.presentCurrencyList()
    }
}

//MARK: - Configuration

extension PriceView {
    
    private func configurePriceLabel() {
        self.addSubview(priceLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.text = "금액"
        priceLabel.font = .preferredFont(forTextStyle: .callout)
        
        let labelConstraints = [
            priceLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 8),
            priceLabel.widthAnchor.constraint(equalTo: self.widthAnchor,
                                              multiplier: 0.1)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    private func configurePriceImage() {
        self.addSubview(swapCurrencyButton)
        
        swapCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        swapCurrencyButton.configuration = buttonConfiguration()
        
        swapCurrencyButton.setTitle("KRW(원)",
                                    for: .normal)
        swapCurrencyButton.setTitleColor(.black,
                                         for: .normal)
        swapCurrencyButton.setImage(UIImage(systemName: "chevron.down"),
                                    for: .normal)
        swapCurrencyButton.addTarget(self,
                                     action: #selector(swapCurrency),
                                     for: .touchUpInside)
        
        let imageConstraints = [
            swapCurrencyButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,
                                            constant: 4),
            swapCurrencyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: -4),
            swapCurrencyButton.heightAnchor.constraint(equalTo: self.widthAnchor,
                                                       multiplier: 0.1),
            swapCurrencyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -4),
            swapCurrencyButton.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                      multiplier: 0.35)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    private func buttonConfiguration() -> UIButton.Configuration {
        
        var configuration = UIButton.Configuration.bordered()
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.cornerStyle = .medium
        
        return configuration
    }
    
    private func configurePriceTextField() {
        self.addSubview(priceTextField)
        
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        priceTextField.textAlignment = .left
        priceTextField.font = .preferredFont(forTextStyle: .title3)
        priceTextField.placeholder = "금액을 입력하세요"
        priceTextField.keyboardType = .numberPad
        priceTextField.addTarget(self,
                                 action: #selector(didTextFieldChange),
                                 for: .editingChanged)
        
        let textFieldConstraints = [
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,
                                                constant: 4),
            priceTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                   constant: -4),
            priceTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                    constant: 8),
            priceTextField.trailingAnchor.constraint(equalTo: swapCurrencyButton.leadingAnchor,
                                                     constant: -8)
        ]
        
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
    private func configureUnderLine(size: CGFloat, color: CGColor?) {
        let underLine = CALayer()
        self.layer.addSublayer(underLine)
        underLine.backgroundColor = color
        
        underLine.frame = CGRect(origin: CGPoint(x: priceTextField.frame.origin.x,
                                                 y: self.frame.height),
                                 size: CGSize(width: priceTextField.frame.width,
                                              height: size))
        
    }
}
